alter table "public"."notifications" add column "metadatas" jsonb not null default '{}'::jsonb;

set check_function_bodies = off;

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
    INSERT INTO public.notifications (user_id, title, body, type, metadatas)
    VALUES (
        NEW.user_id, 
        challenge_title, 
        FORMAT('You have been invited by %s', challenge_creator_username), 
        'invitation',
        jsonb_set(
            '{}'::jsonb,  -- Start with empty JSONB if null
            '{challenge_id}',                   -- JSON path to update
            to_jsonb(NEW.challenge_id::TEXT),       -- Value to insert
            true                                -- Create path if it does not exist
        )
    );

    RETURN NEW;
END;$function$
;


