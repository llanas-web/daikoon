drop policy "Allow UPDATE to challenge creator" on "public"."participants";

alter type "public"."notification_type" rename to "notification_type__old_version_to_be_dropped";

create type "public"."notification_type" as enum ('invitation', 'challenge_ended', 'new_message', 'challenge_time_warning');

alter table "public"."notifications" alter column type type "public"."notification_type" using type::text::"public"."notification_type";

drop type "public"."notification_type__old_version_to_be_dropped";

alter table "public"."choices" alter column "is_correct" drop default;

alter table "public"."choices" alter column "is_correct" drop not null;

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.dispatch_challenge_time_warning(minutes_before integer DEFAULT 10)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
BEGIN
  INSERT INTO public.notifications (user_id, title, body, type, metadatas)
  SELECT
    r.user_id,
    format('⚠️ Plus que %s min pour "%s"', minutes_before, coalesce(d.challenge_name, d.challenge_id::text)),
    format('Le défi se termine à %s UTC.', to_char(d.limit_date, 'YYYY-MM-DD HH24:MI TZ')),
    'challenge_time_warning'::public.notification_type,
    jsonb_build_object(
      'challenge_id', d.challenge_id::text,
      'minutes_before', minutes_before::text
    )
  FROM (
    SELECT c.id AS challenge_id, c.title AS challenge_name, c.limit_date
    FROM public.challenges c
    WHERE c.limit_date IS NOT NULL
      AND c.limit_date >= now() + make_interval(mins => minutes_before)
      AND c.limit_date <  now() + make_interval(mins => minutes_before) + interval '90 seconds'
  ) AS d
  JOIN public.participants r ON r.challenge_id = d.challenge_id
  WHERE NOT EXISTS (
    SELECT 1
    FROM public.notifications n
    WHERE n.user_id = r.user_id
      AND n.type = 'challenge_time_warning'::public.notification_type
      AND n.metadatas->>'challenge_id'  = d.challenge_id::text
      AND n.metadatas->>'minutes_before' = minutes_before::text
  );

  -- No RETURNING, no PERFORM needed.
END;
$function$
;

CREATE OR REPLACE FUNCTION public.handle_new_user()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$DECLARE 
  is_admin boolean;

BEGIN
  IF new.raw_user_meta_data->>'push_token' IS NOT NULL THEN
    UPDATE public.users
    SET push_token = NULL
    WHERE push_token = new.raw_user_meta_data->>'push_token'
    AND id <> new.id;  -- Prevent clearing the token of the row being updated
  END IF;


  insert into public.users (id, email, username, full_name, avatar_url, push_token)
  values (
    new.id, 
    new.email,
    new.raw_user_meta_data->>'username',
    new.raw_user_meta_data->>'full_name',
    new.raw_user_meta_data->>'avatar_url',
    new.raw_user_meta_data->>'push_token'
  );

  insert into public.wallets (user_id, amount)
  values (new.id, 200);

  return new;
end;$function$
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

    -- Update the bet status
    UPDATE public.bets
    SET status = 'done'
    WHERE bets.id = NEW.origin_id;

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

create policy "Allow UPDATE to challenge participants"
on "public"."participants"
as permissive
for update
to authenticated
using (((auth.uid() = user_id) OR is_auth_user_participant_to_challenge(challenge_id)));



