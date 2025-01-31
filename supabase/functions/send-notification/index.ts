import { createClient } from "npm:@supabase/supabase-js@2";
import { JWT } from "npm:google-auth-library@9";

interface Notification {
  id: string;
  title: string;
  user_id: string;
  body: string;
  status: "error" | "pending" | "sent" | "checked";
}

interface WebhookPayload {
  type: "INSERT";
  table: string;
  record: Notification;
  schema: "public";
}

const supabase = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
);

Deno.serve(async (req) => {
  const payload: WebhookPayload = await req.json();
  console.log(payload);
  console.log(Deno.env.get("SUPABASE_URL")!);
  console.log(Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!);

  if (payload.record.user_id == null) {
    return builResponse(405, JSON.stringify({ error: "user_id is required" }));
  }

  const userFcmToken = await getFcmTokenFromUserId(payload.record.user_id);

  if (userFcmToken == null) {
    return builResponse(
      400,
      JSON.stringify({ error: "user has no fcm_token specified" }),
    );
  }

  try {
    await sendNotification(
      userFcmToken,
      payload.record.title,
      payload.record.body,
    );
    await updateNotifications(payload.record.id, "sent");
    return builResponse(204);
  } catch (e) {
    console.error(e);
    await updateNotifications(payload.record.id, "error");
    return builResponse(
      500,
      JSON.stringify({ error: "failed to send notification" }),
    );
  }
});

const getFcmTokenFromUserId = async (userId: string) => {
  const { data: user } = await supabase
    .from("users")
    .select("fcm_token")
    .eq("id", userId)
    .single();

  return user?.fcm_token as string | null;
};

const updateNotifications = async (notificationId: string, status: string) => {
  await supabase.from("notifications").update({ status }).eq(
    "id",
    notificationId,
  );
};

const sendNotification = async (
  fcmToken: string,
  title: string,
  body: string,
) => {
  const { default: serviceAccount } = await import(
    "../service-account.json",
    {
      with: { type: "json" },
    }
  );

  const accessToken = await getAccessToken({
    clientEmail: serviceAccount.client_email,
    privateKey: serviceAccount.private_key,
  });

  console.log(accessToken);

  const notificationContent = {
    title,
    body,
  };

  const res = await fetch(
    `https://fcm.googleapis.com/v1/projects/${serviceAccount.project_id}/messages:send`,
    {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${accessToken}`,
      },
      body: JSON.stringify({
        message: {
          token: fcmToken,
          notification: notificationContent,
        },
      }),
    },
  );

  console.log(res.status);

  const resData = await res.json();

  console.log(resData);
  if (res.status < 200 || 299 < res.status) {
    throw resData;
  }
};

const getAccessToken = ({
  clientEmail,
  privateKey,
}: {
  clientEmail: string;
  privateKey: string;
}): Promise<string> => {
  return new Promise((resolve, reject) => {
    const jwtClient = new JWT({
      email: clientEmail,
      key: privateKey,
      scopes: ["https://www.googleapis.com/auth/firebase.messaging"],
    });
    jwtClient.authorize((err, tokens) => {
      if (err) {
        reject(err);
        return;
      }
      resolve(tokens!.access_token!);
    });
  });
};

const builResponse = (status: number, body?: string) => {
  return new Response(body, {
    status,
    headers: { "Content-Type": "application/json" },
  });
};
