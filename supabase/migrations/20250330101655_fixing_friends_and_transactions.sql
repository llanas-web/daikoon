alter table "public"."users" drop constraint "users_fcm_token_key";

drop index if exists "public"."users_fcm_token_key";

set check_function_bodies = off;

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

CREATE OR REPLACE FUNCTION public.handle_update_user()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$BEGIN
  IF new.raw_user_meta_data->>'push_token' IS NOT NULL THEN
    UPDATE public.users
    SET push_token = NULL
    WHERE push_token = new.raw_user_meta_data->>'push_token'
    AND id <> new.id;  -- Prevent clearing the token of the row being updated
  END IF;

  update public.users
  set full_name = new.raw_user_meta_data->>'full_name',
      email = new.email,
      username = new.raw_user_meta_data->>'username',
      avatar_url = new.raw_user_meta_data->>'avatar_url',
      push_token = new.raw_user_meta_data->>'push_token'
  where id = new.id;
  return new;
END;$function$
;


