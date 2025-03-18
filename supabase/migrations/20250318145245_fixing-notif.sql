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
    notification_body TEXT;

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
        SELECT bets.user_id, bets.amount, choices.is_correct, bets.created_at
        FROM public.choices
        JOIN public.bets ON bets.choice_id = choices.id
        WHERE choices.challenge_id = NEW.challenge_id
    LOOP
        IF participant_record.is_correct THEN
            notification_body := 'Vous avez gagné la partie!';
        ELSE
            notification_body := 'Vous avez perdu la partie...';
        END IF;
         -- Insert the notification
        INSERT INTO public.notifications (user_id, title, body, type, metadatas)
        VALUES (
            participant_record.user_id, 
            challenge_title, 
            notification_body, 
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

CREATE OR REPLACE FUNCTION public.create_notif_challenge_invitation()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
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
        FORMAT('@%s Vous a invité à participer à un défi', challenge_creator_username), 
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


