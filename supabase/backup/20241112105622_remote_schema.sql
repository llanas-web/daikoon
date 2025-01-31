alter table "public"."challenges" add column "has_bet" boolean not null default true;

alter table "public"."challenges" add column "max_bet" bigint;

alter table "public"."challenges" add column "min_bet" bigint;

alter table "public"."transactions" alter column "receiver_id" drop not null;

alter table "public"."transactions" alter column "sender_id" drop not null;


set check_function_bodies = off;

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


