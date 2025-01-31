revoke delete on table "public"."challenge_title" from "anon";

revoke insert on table "public"."challenge_title" from "anon";

revoke references on table "public"."challenge_title" from "anon";

revoke select on table "public"."challenge_title" from "anon";

revoke trigger on table "public"."challenge_title" from "anon";

revoke truncate on table "public"."challenge_title" from "anon";

revoke update on table "public"."challenge_title" from "anon";

revoke delete on table "public"."challenge_title" from "authenticated";

revoke insert on table "public"."challenge_title" from "authenticated";

revoke references on table "public"."challenge_title" from "authenticated";

revoke select on table "public"."challenge_title" from "authenticated";

revoke trigger on table "public"."challenge_title" from "authenticated";

revoke truncate on table "public"."challenge_title" from "authenticated";

revoke update on table "public"."challenge_title" from "authenticated";

revoke delete on table "public"."challenge_title" from "service_role";

revoke insert on table "public"."challenge_title" from "service_role";

revoke references on table "public"."challenge_title" from "service_role";

revoke select on table "public"."challenge_title" from "service_role";

revoke trigger on table "public"."challenge_title" from "service_role";

revoke truncate on table "public"."challenge_title" from "service_role";

revoke update on table "public"."challenge_title" from "service_role";

drop table "public"."challenge_title";

alter table "public"."challenges" add column "amount" bigint not null default '0'::bigint;

CREATE UNIQUE INDEX wallets_pkey ON public.wallets USING btree (user_id);

alter table "public"."wallets" add constraint "wallets_pkey" PRIMARY KEY using index "wallets_pkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.create_transaction_from_bet()
 RETURNS trigger
 LANGUAGE plpgsql
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

CREATE OR REPLACE FUNCTION public.make_transaction()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$DECLARE
  is_admin BOOLEAN;
  challenge_id UUID;
  user_wallet_new_value INT;
BEGIN
  -- If there is a sender , 
  IF (NEW.sender_id IS NOT NULL)
    AND (NEW.receiver_id IS NULL)
    AND (NEW.origin_id IS NOT NULL)
  THEN

    -- Get the challenge corresponding
    SELECT 
      choices.challenge_id AS challenge_id,
      bets.id as bet_id
    INTO challenge_id
    FROM public.bets
    JOIN public.choices
    ON bets.choice_id = choices.id
    WHERE bets.id = NEW.origin_id;

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

    -- Update transaction to done
    UPDATE public.transactions
    SET status = 'done'
    WHERE transactions.id = NEW.id;
  END IF;

  RETURN NEW;
END;$function$
;

CREATE TRIGGER on_new_bet AFTER INSERT ON public.bets FOR EACH ROW EXECUTE FUNCTION create_transaction_from_bet();

CREATE TRIGGER on_new_transaction AFTER INSERT ON public.transactions FOR EACH ROW EXECUTE FUNCTION make_transaction();


