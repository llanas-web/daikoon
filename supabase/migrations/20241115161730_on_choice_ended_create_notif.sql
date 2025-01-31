drop trigger if exists "on-notification-insert" on "public"."notifications";

drop trigger if exists "on-participant-insert" on "public"."participants";

drop function if exists "public"."create-notif-challenge-invitation"();

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.create_notif_challenge_ended()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$DECLARE
    is_admin BOOLEAN;
    challenge_title TEXT;
    challenge_creator_username TEXT;
    participant_user_id UUID;
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

    -- Loop through each user_id from the participant table
    FOR participant_user_id IN 
        SELECT user_id 
        FROM public.participants
        WHERE challenge_id = NEW.challenge_id
    LOOP
         -- Insert the notification
        INSERT INTO public.notifications (user_id, title, body, type)
        VALUES (
            participant_user_id, 
            challenge_title, 
            FORMAT('%s has declared a winner! See if you have win!', challenge_creator_username), 
            'challenge-ended'
        );

    END LOOP;

    RETURN NEW;
END;$function$
;

CREATE OR REPLACE FUNCTION public.create_notif_challenge_invitation()
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

CREATE TRIGGER on_choice_update AFTER UPDATE ON public.choices FOR EACH ROW WHEN (((new.is_correct = true) AND (old.is_correct IS DISTINCT FROM new.is_correct))) EXECUTE FUNCTION create_notif_challenge_ended();

CREATE TRIGGER on_notification_insert AFTER INSERT ON public.notifications FOR EACH ROW EXECUTE FUNCTION supabase_functions.http_request('https://host.docker.internal:54321/functions/v1/send-notification', 'POST', '{"Content-type":"application/json","Authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0"}', '{}', '5000');

CREATE TRIGGER on_participant_insert AFTER INSERT ON public.participants FOR EACH ROW EXECUTE FUNCTION create_notif_challenge_invitation();


