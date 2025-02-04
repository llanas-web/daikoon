alter table "public"."friendships" drop constraint "relationship_user_asked_fkey";

alter table "public"."friendships" drop constraint "relationship_user_id_fkey";

alter table "public"."bets" drop constraint "bets_choice_id_fkey";

alter table "public"."bets" drop constraint "bets_user_id_fkey";

alter table "public"."challenges" drop constraint "challenges_creator_id_fkey";

alter table "public"."friendships" drop constraint "friendships_receiver_id_fkey";

alter table "public"."friendships" drop constraint "friendships_sender_id_fkey";

alter table "public"."notifications" drop constraint "notifications_user_id_fkey";

alter table "public"."participants" drop constraint "participants_challenge_id_fkey";

alter table "public"."transactions" drop constraint "transactions_origin_id_fkey";

alter table "public"."transactions" drop constraint "transactions_receiver_id_fkey";

alter table "public"."transactions" drop constraint "transactions_sender_id_fkey";

alter table "public"."wallets" drop constraint "wallets_user_id_fkey";

alter table "public"."bets" enable row level security;

alter table "public"."challenges" enable row level security;

alter table "public"."choices" enable row level security;

alter table "public"."friendships" enable row level security;

alter table "public"."notifications" enable row level security;

alter table "public"."participants" enable row level security;

alter table "public"."transactions" enable row level security;

alter table "public"."users" enable row level security;

alter table "public"."wallets" enable row level security;

alter table "public"."bets" add constraint "bets_choice_id_fkey" FOREIGN KEY (choice_id) REFERENCES choices(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."bets" validate constraint "bets_choice_id_fkey";

alter table "public"."bets" add constraint "bets_user_id_fkey" FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."bets" validate constraint "bets_user_id_fkey";

alter table "public"."challenges" add constraint "challenges_creator_id_fkey" FOREIGN KEY (creator_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE SET DEFAULT not valid;

alter table "public"."challenges" validate constraint "challenges_creator_id_fkey";

alter table "public"."friendships" add constraint "friendships_receiver_id_fkey" FOREIGN KEY (receiver_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."friendships" validate constraint "friendships_receiver_id_fkey";

alter table "public"."friendships" add constraint "friendships_sender_id_fkey" FOREIGN KEY (sender_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."friendships" validate constraint "friendships_sender_id_fkey";

alter table "public"."notifications" add constraint "notifications_user_id_fkey" FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."notifications" validate constraint "notifications_user_id_fkey";

alter table "public"."participants" add constraint "participants_challenge_id_fkey" FOREIGN KEY (challenge_id) REFERENCES challenges(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."participants" validate constraint "participants_challenge_id_fkey";

alter table "public"."transactions" add constraint "transactions_origin_id_fkey" FOREIGN KEY (origin_id) REFERENCES bets(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."transactions" validate constraint "transactions_origin_id_fkey";

alter table "public"."transactions" add constraint "transactions_receiver_id_fkey" FOREIGN KEY (receiver_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE SET DEFAULT not valid;

alter table "public"."transactions" validate constraint "transactions_receiver_id_fkey";

alter table "public"."transactions" add constraint "transactions_sender_id_fkey" FOREIGN KEY (sender_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE SET DEFAULT not valid;

alter table "public"."transactions" validate constraint "transactions_sender_id_fkey";

alter table "public"."wallets" add constraint "wallets_user_id_fkey" FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."wallets" validate constraint "wallets_user_id_fkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.is_auth_user_challenge_creator(_challenge_id uuid)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$BEGIN
  RETURN EXISTS ( SELECT 1
   FROM challenges
  WHERE ((challenges.id = choices.challenge_id) AND (challenges.creator_id = auth.uid())));
END;$function$
;

CREATE OR REPLACE FUNCTION public.is_auth_user_friend_to_user_id(_user_id uuid)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$BEGIN
  RETURN EXISTS(
    SELECT 1
    FROM public.friendships
    WHERE (
      (
        friendships.sender_id = auth.uid()
        AND friendships.receiver_id = _user_id
      ) OR (
        friendships.sender_id = _user_id
        AND friendships.receiver_id = auth.uid()
      )
    )
  );
END;$function$
;

CREATE OR REPLACE FUNCTION public.is_auth_user_participant_to_challenge(_challenge_id uuid)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$BEGIN
  RETURN EXISTS(
    SELECT 1
    FROM public.participants
    WHERE (
      participants.user_id = auth.uid()
      AND participants.challenge_id = _challenge_id
    )
  );
END;$function$
;

create policy "Allow ALL to own user"
on "public"."bets"
as permissive
for all
to authenticated
using ((auth.uid() = user_id));


create policy "Allow ALL to creator "
on "public"."challenges"
as permissive
for all
to authenticated
using ((creator_id = auth.uid()));


create policy "Allow DELETE to challenge creator"
on "public"."choices"
as permissive
for delete
to authenticated
using (is_auth_user_challenge_creator(challenge_id));


create policy "Allow INSERT to challenge creator"
on "public"."choices"
as permissive
for insert
to authenticated
with check (is_auth_user_challenge_creator(challenge_id));


create policy "Allow SELECT to challenge participants"
on "public"."choices"
as permissive
for select
to public
using (is_auth_user_participant_to_challenge(challenge_id));


create policy "Allow UPDATE to challenge creator"
on "public"."choices"
as permissive
for update
to authenticated
using (is_auth_user_challenge_creator(challenge_id));


create policy "Allow ALL to own user"
on "public"."friendships"
as permissive
for all
to authenticated
using (((auth.uid() = sender_id) OR (auth.uid() = receiver_id)));


create policy "Allow SELECT to own user"
on "public"."notifications"
as permissive
for select
to authenticated
using ((auth.uid() = user_id));


create policy "Allow DELETE to challenge creator"
on "public"."participants"
as permissive
for delete
to authenticated
using (is_auth_user_challenge_creator(challenge_id));


create policy "Allow INSERT to challenge creator"
on "public"."participants"
as permissive
for insert
to authenticated
with check (is_auth_user_challenge_creator(challenge_id));


create policy "Allow SELECT to challenge participants"
on "public"."participants"
as permissive
for select
to authenticated
using (((auth.uid() = user_id) OR is_auth_user_participant_to_challenge(challenge_id)));


create policy "Allow UPDATE to challenge creator"
on "public"."participants"
as permissive
for update
to authenticated
using (is_auth_user_challenge_creator(challenge_id));


create policy "Allow SELECT to own user"
on "public"."transactions"
as permissive
for select
to authenticated
using (((auth.uid() = sender_id) OR (auth.uid() = receiver_id)));


create policy "Allow SELECT to own or friends users"
on "public"."users"
as permissive
for select
to authenticated
using (((auth.uid() = id) OR is_auth_user_friend_to_user_id(id)));


create policy "Allow SELECT own user"
on "public"."wallets"
as permissive
for select
to authenticated
using ((auth.uid() = user_id));



