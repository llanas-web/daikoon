drop trigger if exists "on_new_bet" on "public"."bets";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.create_transaction_from_bet()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$DECLARE
    is_admin BOOLEAN;
BEGIN

    IF NEW.amount = 0 THEN
        -- No money to move → immediately done
        NEW.status := 'done';
        RETURN NEW;
    END IF;
    
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

CREATE TRIGGER on_new_bet BEFORE INSERT ON public.bets FOR EACH ROW EXECUTE FUNCTION create_transaction_from_bet();


