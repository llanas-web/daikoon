set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.handle_new_user()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$declare 
  is_admin boolean;
  username text;
  provider text;

begin
    -- Get the auth provider
  provider := (new.raw_app_meta_data->>'provider');

  -- Default username handling
  if provider = 'email' then
    username := new.raw_user_meta_data->>'username';
  end if;

  -- If provider is Google or username is still null, extract from email
  if provider = 'google' or username is null then
    username := split_part(new.email, '@', 1);
  end if;

  insert into public.users (id, email, username)
  values (new.id, new.email, username);

  insert into public.wallets (user_id)
  values (new.id);

  return new;
end;$function$
;


