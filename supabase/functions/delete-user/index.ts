import { createClient } from "jsr:@supabase/supabase-js@2.47.0";

const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
);

Deno.serve(async (req) => {
    const { user_id } = await req.json();

    if (user_id == null) {
        return builResponse(
            405,
            JSON.stringify({ error: "user_id is required" }),
        );
    }

    const { error } = await supabase.auth.admin.deleteUser(user_id);
    if (error) {
        return builResponse(400, JSON.stringify({ error: error.message }));
    }
    return builResponse(204);
});

const builResponse = (status: number, body?: string) => {
    return new Response(body, {
        status,
        headers: { "Content-Type": "application/json" },
    });
};
