import { createClient } from "jsr:@supabase/supabase-js@2.47.0";
import { FcmClient } from "https://deno.land/x/firebase_messaging@1.0.4/mod.ts";

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

const serviceAccount = JSON.parse(Deno.env.get("GOOGLE_SERVICE_JSON")!);

const fcmClient = new FcmClient(serviceAccount);

Deno.serve(async (req) => {
  const payload: WebhookPayload = await req.json();
  const { user_id, body, title } = payload.record;

  if (payload.record.user_id == null) {
    return builResponse(405, JSON.stringify({ error: "user_id is required" }));
  }

  const { data: user } = await supabase
    .from("users")
    .select("push_token")
    .eq("id", user_id)
    .single();

  if (user?.push_token == null) {
    return builResponse(
      400,
      JSON.stringify({ error: "user has no fcm_token specified" }),
    );
  }

  try {
    const response = await fcmClient.sendNotification(
      {
        notification: {
          title,
          body,
        },
        token: user?.push_token,
      },
    );
    console.dir(response);
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

const updateNotifications = async (notificationId: string, status: string) => {
  await supabase.from("notifications").update({ status }).eq(
    "id",
    notificationId,
  );
};

const builResponse = (status: number, body?: string) => {
  return new Response(body, {
    status,
    headers: { "Content-Type": "application/json" },
  });
};
