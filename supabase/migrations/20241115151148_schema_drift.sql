create extension if not exists "http" with schema "extensions";

create extension if not exists "wrappers" with schema "extensions";


create type "public"."notification_status" as enum ('error', 'pending', 'sent', 'checked');

create type "public"."notification_type" as enum ('invitation', 'challenge-ended', 'new-message');

drop trigger if exists "on-challenge-end" on "public"."choices";

drop trigger if exists "on-participant-insert" on "public"."participants";

alter table "public"."notifications" drop constraint "notifications_challenge_id_fkey";

create table "public"."challenge_title" (
    "title" text
);


alter table "public"."notifications" drop column "challenge_id";

alter table "public"."notifications" drop column "is_checked";

alter table "public"."notifications" add column "status" notification_status not null default 'pending'::notification_status;

alter table "public"."notifications" add column "type" notification_type;

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public."create-notif-challenge-invitation"()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$DECLARE
    is_admin BOOLEAN;
    participant_username TEXT;
    challenge_title TEXT;
    challenge_creator_username TEXT;
BEGIN
    SELECT 
        challenges.title AS challenge_title,
        users.username AS creator_name
    INTO 
        challenge_title, 
        challenge_creator_username
    FROM public.challenges
    JOIN public.users
    ON challenges.creator_id = users.id
    WHERE challenges.id = NEW.challenge_id;

    -- Insert the notification
    INSERT INTO public.notifications (user_id, title, body, type)
    VALUES (
        NEW.user_id, 
        challenge_title, 
        FORMAT('You have been invited by %s', challenge_creator_username), 
        'invitation'
    );

    RETURN NEW;
END;$function$
;

grant delete on table "public"."challenge_title" to "anon";

grant insert on table "public"."challenge_title" to "anon";

grant references on table "public"."challenge_title" to "anon";

grant select on table "public"."challenge_title" to "anon";

grant trigger on table "public"."challenge_title" to "anon";

grant truncate on table "public"."challenge_title" to "anon";

grant update on table "public"."challenge_title" to "anon";

grant delete on table "public"."challenge_title" to "authenticated";

grant insert on table "public"."challenge_title" to "authenticated";

grant references on table "public"."challenge_title" to "authenticated";

grant select on table "public"."challenge_title" to "authenticated";

grant trigger on table "public"."challenge_title" to "authenticated";

grant truncate on table "public"."challenge_title" to "authenticated";

grant update on table "public"."challenge_title" to "authenticated";

grant delete on table "public"."challenge_title" to "service_role";

grant insert on table "public"."challenge_title" to "service_role";

grant references on table "public"."challenge_title" to "service_role";

grant select on table "public"."challenge_title" to "service_role";

grant trigger on table "public"."challenge_title" to "service_role";

grant truncate on table "public"."challenge_title" to "service_role";

grant update on table "public"."challenge_title" to "service_role";

CREATE TRIGGER "on-notification-insert" AFTER INSERT ON public.notifications FOR EACH ROW EXECUTE FUNCTION supabase_functions.http_request('https://host.docker.internal:54321/functions/v1/send-notification', 'POST', '{"Content-type":"application/json","Authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0"}', '{}', '5000');

CREATE TRIGGER "on-participant-insert" AFTER INSERT ON public.participants FOR EACH ROW EXECUTE FUNCTION "create-notif-challenge-invitation"();


