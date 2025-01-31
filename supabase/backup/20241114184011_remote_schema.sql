alter table "public"."transactions" alter column "status" set not null;

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.handle_new_user()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
declare is_admin boolean;
begin
  insert into public.users (id, email, username)
  values (new.id, new.email, split_part(new.email, '@', 1));
  return new;
end;
$function$
;

CREATE OR REPLACE FUNCTION public.push_friends(user_id uuid, friend_id uuid)
 RETURNS users
 LANGUAGE sql
AS $function$
  update public.users
  set friends = array_append(friends, friend_id)
  where id = user_id
  returning *;
$function$
;


