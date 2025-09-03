drop trigger if exists "on_new_bet" on "public"."bets";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.create_transaction_from_bet()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$BEGIN
  IF NEW.amount = 0 THEN
    -- finalize immediately (no transaction)
    UPDATE public.bets
       SET status = 'done'
     WHERE id = NEW.id
       AND status IS DISTINCT FROM 'done';
  ELSE
    -- ensure pending if not set
    UPDATE public.bets
       SET status = COALESCE(status, 'pending')
     WHERE id = NEW.id;

    INSERT INTO public.transactions (sender_id, origin_id, amount)
    VALUES (NEW.user_id, NEW.id, NEW.amount)
    ON CONFLICT (origin_id) DO NOTHING;  -- idempotency guard
  END IF;

  RETURN NULL; -- ignored for AFTER triggers
END;$function$
;

CREATE TRIGGER on_new_bet AFTER INSERT ON public.bets FOR EACH ROW EXECUTE FUNCTION create_transaction_from_bet();


