create type "public"."bet_status" as enum ('pending', 'done');

alter table "public"."bets" add column "status" bet_status not null default 'pending'::bet_status;

set check_function_bodies = off;

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


