set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.handle_new_user()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$declare is_admin boolean;
begin
  insert into public.users (id, email, username)
  values (new.id, new.email, split_part(new.email, '@', 1));

  insert into public.wallets (user_id)
  values (new.id);

  return new;
end;$function$
;


