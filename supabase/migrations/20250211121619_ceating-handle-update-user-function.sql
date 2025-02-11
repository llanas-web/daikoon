alter table "public"."users" drop constraint "users_fcm_token_key";

drop index if exists "public"."users_fcm_token_key";

alter table "public"."users" drop column "fcm_token";

alter table "public"."users" add column "full_name" text;

alter table "public"."users" add column "push_token" text;

CREATE UNIQUE INDEX users_fcm_token_key ON public.users USING btree (push_token);

alter table "public"."users" add constraint "users_fcm_token_key" UNIQUE using index "users_fcm_token_key";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.handle_update_user()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$BEGIN
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

CREATE OR REPLACE FUNCTION public.handle_new_user()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$DECLARE 
  is_admin boolean;

BEGIN
  insert into public.users (id, email, username, full_name, push_token)
  values (
    new.id, 
    new.email,
    new.raw_user_meta_data->>'username',
    new.raw_user_meta_data->>'full_name',
    new.raw_user_meta_data->>'avatar_url',
    new.raw_user_meta_data->>'push_token'
  );

  insert into public.wallets (user_id)
  values (new.id);

  return new;
end;$function$
;


CREATE TRIGGER on_update_user AFTER UPDATE ON auth.users FOR EACH ROW EXECUTE FUNCTION handle_update_user();


