drop trigger if exists "on_notification_insert" on "public"."notifications";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.create_notif_challenge_ended()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$DECLARE
    is_admin BOOLEAN;
    -- notification variable
    participant_record RECORD;
    challenge_title TEXT;
    challenge_creator_username TEXT;
    challenge_has_bet BOOLEAN;
    -- transaction variable
    bet_record RECORD;
    participants_length INT;
    modulo BOOLEAN;
    challenge_amount INT;
    amount_by_participant INT;
BEGIN
    SELECT 
        challenges.title AS challenge_title,
        challenges.has_bet AS challenge_has_bet,
        challenges.amount AS challenge_amount,
        users.username AS creator_name
    INTO 
        challenge_title, 
        challenge_has_bet,
        challenge_amount,
        challenge_creator_username

    FROM public.challenges
    JOIN public.users
    ON challenges.creator_id = users.id
    WHERE challenges.id = NEW.challenge_id;

    -- Loop through each user_id from the participant table
    FOR participant_record IN 
        SELECT user_id 
        FROM public.participants
        WHERE challenge_id = NEW.challenge_id
    LOOP
         -- Insert the notification
        INSERT INTO public.notifications (user_id, title, body, type, metadatas)
        VALUES (
            participant_record.user_id, 
            challenge_title, 
            FORMAT('%s has declared a winner! See if you have win!', challenge_creator_username), 
            'challenge_ended',
            jsonb_set(
                '{}'::jsonb,  -- Start with empty JSONB if null
                '{challenge_id}',                   -- JSON path to update
                to_jsonb(NEW.challenge_id::TEXT),       -- Value to insert
                true                                -- Create path if it does not exist
            )
        );

    END LOOP;

    IF challenge_has_bet
    THEN 

        SELECT COUNT(*) INTO participants_length
        FROM public.bets
        WHERE bets.choice_id = NEW.id;

        modulo := (challenge_amount % participants_length) != 0;
        amount_by_participant := FLOOR(challenge_amount / participants_length);

        -- Loop through each user_id from the participant who voted for this choice
        FOR bet_record IN 
            SELECT id, user_id
            FROM public.bets
            WHERE choice_id = NEW.id
            ORDER BY created_at ASC
        LOOP
            -- Insert the notification
            INSERT INTO public.transactions (receiver_id, origin_id, amount, status)
            VALUES (
                bet_record.user_id, 
                bet_record.id, 
                CASE 
                WHEN modulo = true THEN amount_by_participant + 1
                ELSE amount_by_participant
                END,
                'pending'
            );
            modulo := FALSE;
        END LOOP;
    END IF;

    RETURN NEW;
END;$function$
;

CREATE OR REPLACE FUNCTION public.create_transaction_from_bet()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$DECLARE
    is_admin BOOLEAN;
BEGIN
      -- Insert the transaction
    IF new.amount > 0
    THEN
        INSERT INTO public.transactions (sender_id, origin_id, amount)
        VALUES (
            NEW.user_id, 
            NEW.id, 
            NEW.amount
        );
    END IF;

    RETURN NEW;
END;$function$
;

CREATE TRIGGER on_notification_insert AFTER INSERT ON public.notifications FOR EACH ROW EXECUTE FUNCTION call_edge_function('/functions/v1/send-notification', 'POST', '{"Content-type":"application/json","x-supabase-webhook-source":"whatever"}', '{}', '5000');


