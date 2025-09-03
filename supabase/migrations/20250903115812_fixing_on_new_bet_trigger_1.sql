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
    INSERT INTO public.transactions (sender_id, origin_id, amount)
    VALUES (NEW.user_id, NEW.id, NEW.amount);
  END IF;

  RETURN NEW; -- ignored for AFTER triggers
END;$function$
;


