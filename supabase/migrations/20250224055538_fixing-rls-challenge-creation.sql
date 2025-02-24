drop policy "Allow SELECT to own user" on "public"."notifications";

drop policy "Allow SELECT to challenge participants" on "public"."choices";

drop function if exists "public"."push_friends"(user_id uuid, friend_id uuid);

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
    -- transaction variable
    bet_record RECORD;
    participants_length INT;
    modulo BOOLEAN;
    challenge_amount INT;
    amount_by_participant INT;
BEGIN
    SELECT 
        challenges.title AS challenge_title,
        challenges.amount AS challenge_amount,
        users.username AS creator_name
    INTO 
        challenge_title, 
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

CREATE OR REPLACE FUNCTION public.create_transaction_from_bet()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$DECLARE
    is_admin BOOLEAN;
BEGIN
      -- Insert the transaction
    INSERT INTO public.transactions (sender_id, origin_id, amount)
    VALUES (
        NEW.user_id, 
        NEW.id, 
        NEW.amount
    );

    RETURN NEW;
END;$function$
;

CREATE OR REPLACE FUNCTION public.create_transaction_from_challenge()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$DECLARE
    is_admin BOOLEAN;
    participants_length INT;
    modulo BOOLEAN;
    amount_by_participant INT;
    participant_user_id UUID;
BEGIN
    SELECT COUNT(*) INTO participants_length
    FROM public.bets
    WHERE bets.choice_id = NEW.id;

    modulo := (NEW.amount % participants_length) != 0;
    amount_by_participant := FLOOR(NEW.amount / participants_length);

    -- Loop through each user_id from the participant who voted for this choice
    FOR participant_user_id IN 
        SELECT user_id 
        FROM public.bets
        WHERE choice_id = NEW.id
    LOOP
         -- Insert the notification
        INSERT INTO public.transactions (receiver_id, origin_id, amount, status)
        VALUES (
            participant_user_id, 
            NEW.challenge_id, 
            CASE 
              WHEN modulo == true THEN amount_by_participant + 1
              ELSE amount_by_participant
            END,
            'pending'
        );
        modulo := FALSE;
    END LOOP;

    RETURN NEW;
END;$function$
;

CREATE OR REPLACE FUNCTION public.is_auth_user_challenge_creator(_challenge_id uuid)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$DECLARE 
  challenge_count int;

BEGIN
  RAISE LOG 'Is % the creator of %', auth.uid(), _challenge_id;
  
  SELECT COUNT(*) INTO challenge_count    
  FROM challenges
  WHERE challenges.id = _challenge_id AND challenges.creator_id = auth.uid();
  
  RAISE LOG 'There is % challenges table', challenge_count;

  RETURN challenge_count > 0;
END;$function$
;

CREATE OR REPLACE FUNCTION public.is_auth_user_participant_to_challenge(_challenge_id uuid)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$BEGIN
  RETURN EXISTS(
    SELECT 1
    FROM public.participants
    WHERE (
      participants.user_id = auth.uid()
      AND participants.challenge_id = _challenge_id
    )
  );
END;$function$
;

CREATE OR REPLACE FUNCTION public.make_transaction()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$DECLARE
  is_admin BOOLEAN;
  challenge_id UUID;
  user_wallet_new_value INT;
  challenge_amount_new_value INT;
BEGIN

  IF NEW.origin_id IS NULL THEN
    RAISE EXCEPTION 'No bet origin for this transaction';
  END IF;

  -- Get the challenge corresponding
    SELECT 
      choices.challenge_id AS challenge_id,
      bets.id as bet_id
    INTO challenge_id
    FROM public.bets
    JOIN public.choices
    ON bets.choice_id = choices.id
    WHERE bets.id = NEW.origin_id;

  -- If there is a sender
  IF (NEW.sender_id IS NOT NULL)
    AND (NEW.receiver_id IS NULL)
  THEN
    -- Set the amount to the challenge
    UPDATE public.challenges
    SET amount = amount + NEW.amount
    WHERE challenges.id = challenge_id;

    -- Remove the value from the user wallet
    UPDATE public.wallets
    SET amount = amount - NEW.amount
    WHERE wallets.user_id = NEW.sender_id
    RETURNING amount INTO user_wallet_new_value;

    IF user_wallet_new_value < 0 THEN
      RAISE EXCEPTION 'The user has not enought money in his wallet (%) for this transaction', user_wallet_new_value;
    END IF;

  END IF;

   -- If there is a sender
  IF (NEW.sender_id IS NULL)
    AND (NEW.receiver_id IS NOT NULL)
  THEN
    -- Remove the amount to the challenge
    UPDATE public.challenges
    SET amount = amount - NEW.amount
    WHERE challenges.id = challenge_id
    RETURNING amount INTO challenge_amount_new_value;

    -- Add the value from the user wallet
    UPDATE public.wallets
    SET amount = amount + NEW.amount
    WHERE wallets.user_id = NEW.receiver_id;

    IF user_wallet_new_value < 0 THEN
      RAISE EXCEPTION 'The challenge has not enought money (%) for this transaction', challenge_amount_new_value;
    END IF;

  END IF;

  -- Update transaction to done
  UPDATE public.transactions
  SET status = 'done'
  WHERE transactions.id = NEW.id;

  RETURN NEW;
END;$function$
;

CREATE OR REPLACE FUNCTION public.on_challenge_end_wrapper()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$BEGIN
    PERFORM create_notif_challenge_ended(NEW);
    PERFORM create_transaction_from_challenge(NEW);

    RETURN NEW;
END;$function$
;

create policy "Allow ALL to own user"
on "public"."notifications"
as permissive
for all
to authenticated
using ((auth.uid() = user_id));


create policy "Allow SELECT to challenge participants"
on "public"."choices"
as permissive
for select
to public
using ((is_auth_user_challenge_creator(challenge_id) OR is_auth_user_participant_to_challenge(challenge_id)));



