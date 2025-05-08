alter table "public"."users" drop constraint if exists "users_fcm_token_key";

alter table "public"."challenges" drop constraint if exists "challenges_creator_id_fkey";

drop index if exists "public"."users_fcm_token_key";

alter table "public"."transactions" alter column "status" drop default;

alter type "public"."transaction_status" rename to "transaction_status__old_version_to_be_dropped";

create type "public"."transaction_status" as enum ('pending', 'done', 'reversed');

alter table "public"."transactions" alter column status type "public"."transaction_status" using status::text::"public"."transaction_status";

alter table "public"."transactions" alter column "status" set default 'pending'::transaction_status;

drop type "public"."transaction_status__old_version_to_be_dropped";

alter table "public"."challenges" add constraint "challenges_creator_id_fkey" FOREIGN KEY (creator_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."challenges" validate constraint "challenges_creator_id_fkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.create_transaction_from_challenge_deletion()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$DECLARE
    tx RECORD;
BEGIN
    -- Checking if the challenge is still pending and if there is an amount to distribute
    IF(OLD.amount != 0 AND OLD.ending < NOW()) THEN
    -- Loop through all transactions related to bets in this challenge
        FOR tx IN
            SELECT t.*
            FROM transactions t
            JOIN bets b ON b.id = t.origin_id
            JOIN choices c ON c.id = b.choice_id
            WHERE c.challenge_id = OLD.id
        LOOP
            UPDATE transactions
            SET status = 'reversed'
            WHERE id = tx.id;
        END LOOP;
    END IF;
    RETURN OLD;
END;$function$
;

CREATE OR REPLACE FUNCTION public.reverse_transaction()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$DECLARE
  challenge_id UUID;
  user_wallet_new_value INT;
  challenge_amount_new_value INT;
BEGIN
  -- Only reverse transactions that were previously 'done'
  IF (NEW.status = 'reversed' AND OLD.status = 'done') THEN
    IF NEW.origin_id IS NULL THEN
      RAISE EXCEPTION 'No bet origin for this transaction';
    END IF;

    -- Get the challenge ID from the related bet
    SELECT c.challenge_id
    INTO challenge_id
    FROM public.bets b
    JOIN public.choices c ON b.choice_id = c.id
    WHERE b.id = NEW.origin_id;

    -- Case 1: Sender refund (challenge pays user)
    IF NEW.sender_id IS NOT NULL AND NEW.receiver_id IS NULL THEN
      -- Add amount back to user's wallet
      UPDATE public.wallets
      SET amount = amount + NEW.amount
      WHERE user_id = NEW.sender_id;

    -- Case 2: Receiver refund (user pays challenge back)
    ELSIF NEW.sender_id IS NULL AND NEW.receiver_id IS NOT NULL THEN
      -- Add amount back to challenge
      UPDATE public.challenges
      SET amount = amount + NEW.amount
      WHERE id = challenge_id;

      -- Subtract amount from user's wallet, and check if wallet goes negative
      UPDATE public.wallets
      SET amount = amount - NEW.amount
      WHERE user_id = NEW.receiver_id
      RETURNING amount INTO user_wallet_new_value;

      IF user_wallet_new_value < 0 THEN
        RAISE EXCEPTION 'The user wallet has not enough daikoins to reverse this transaction';
      END IF;
    END IF;
  END IF;

  RETURN NEW;
END;$function$
;

create policy "Allow DELETE to own user"
on "public"."users"
as permissive
for delete
to authenticated
using ((auth.uid() = id));


CREATE TRIGGER on_challenge_delete BEFORE DELETE ON public.challenges FOR EACH ROW EXECUTE FUNCTION create_transaction_from_challenge_deletion();

CREATE TRIGGER on_transaction_update BEFORE UPDATE ON public.transactions FOR EACH ROW EXECUTE FUNCTION reverse_transaction();


