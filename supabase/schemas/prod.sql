


SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


CREATE EXTENSION IF NOT EXISTS "pg_cron" WITH SCHEMA "pg_catalog";






CREATE EXTENSION IF NOT EXISTS "pg_net" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgsodium";






COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE EXTENSION IF NOT EXISTS "http" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";






CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgjwt" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "wrappers" WITH SCHEMA "extensions";






CREATE TYPE "public"."bet_status" AS ENUM (
    'pending',
    'done'
);


ALTER TYPE "public"."bet_status" OWNER TO "postgres";


CREATE TYPE "public"."notification_status" AS ENUM (
    'error',
    'pending',
    'sent',
    'checked'
);


ALTER TYPE "public"."notification_status" OWNER TO "postgres";


CREATE TYPE "public"."notification_type" AS ENUM (
    'invitation',
    'challenge_ended',
    'new_message'
);


ALTER TYPE "public"."notification_type" OWNER TO "postgres";


CREATE TYPE "public"."participation_status" AS ENUM (
    'accepted',
    'declined',
    'pending'
);


ALTER TYPE "public"."participation_status" OWNER TO "postgres";


CREATE TYPE "public"."transaction_status" AS ENUM (
    'pending',
    'done'
);


ALTER TYPE "public"."transaction_status" OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."call_edge_function"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'supabase_functions'
    AS $$
  DECLARE
    request_id bigint;
    payload jsonb;
    url_path text := TG_ARGV[0]::text;
    method text := TG_ARGV[1]::text;
    headers jsonb DEFAULT '{}'::jsonb;
    params jsonb DEFAULT '{}'::jsonb;
    timeout_ms integer DEFAULT 1000;
    supabase_project_url text;
    full_url text;
  BEGIN
    IF url_path IS NULL OR url_path = 'null' THEN
      RAISE EXCEPTION 'url_path argument is missing';
    END IF;

    -- Retrieve the base URL from the Vault
    SELECT decrypted_secret INTO supabase_project_url 
    FROM vault.decrypted_secrets 
    WHERE name = 'supabase_project_url';

    IF supabase_project_url IS NULL OR supabase_project_url = 'null' THEN
      RAISE EXCEPTION 'supabase_project_url secret is missing or invalid';
    END IF;
    -- Construct the full URL by concatenating base_url with url_path
    full_url := supabase_project_url || url_path;

    IF method IS NULL OR method = 'null' THEN
      RAISE EXCEPTION 'method argument is missing';
    END IF;

    IF TG_ARGV[2] IS NULL OR TG_ARGV[2] = 'null' THEN
      headers = '{"Content-Type": "application/json"}'::jsonb;
    ELSE
      headers = TG_ARGV[2]::jsonb;
    END IF;

    IF TG_ARGV[3] IS NULL OR TG_ARGV[3] = 'null' THEN
      params = '{}'::jsonb;
    ELSE
      params = TG_ARGV[3]::jsonb;
    END IF;

    IF TG_ARGV[4] IS NULL OR TG_ARGV[4] = 'null' THEN
      timeout_ms = 1000;
    ELSE
      timeout_ms = TG_ARGV[4]::integer;
    END IF;

    CASE
      WHEN method = 'GET' THEN
        SELECT http_get INTO request_id FROM net.http_get(
          full_url,
          params,
          headers,
          timeout_ms
        );
      WHEN method = 'POST' THEN
        payload = jsonb_build_object(
          'old_record', OLD,
          'record', NEW,
          'type', TG_OP,
          'table', TG_TABLE_NAME,
          'schema', TG_TABLE_SCHEMA
        );

        SELECT http_post INTO request_id FROM net.http_post(
          full_url,
          payload,
          params,
          headers,
          timeout_ms
        );
      ELSE
        RAISE EXCEPTION 'method argument % is invalid', method;
    END CASE;

    INSERT INTO supabase_functions.hooks
      (hook_table_id, hook_name, request_id)
    VALUES
      (TG_RELID, TG_NAME, request_id);

    RETURN NEW;
  END;
$$;


ALTER FUNCTION "public"."call_edge_function"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."create_notif_challenge_ended"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$DECLARE
    is_admin BOOLEAN;
    -- notification variable
    participant_record RECORD;
    challenge_title TEXT;
    challenge_creator_username TEXT;
    challenge_has_bet BOOLEAN;
    notification_body TEXT;

    -- transaction variable
    bet_record RECORD;
    participants_length INT;
    modulo BOOLEAN;
    challenge_amount INT;
    amount_by_participant INT;
BEGIN
    SELECT 
        challenges.title AS challenge_title,
        challenges.has_bet AS challenge_has_bet,
        challenges.amount AS challenge_amount,
        users.username AS creator_name
    INTO 
        challenge_title, 
        challenge_has_bet,
        challenge_amount,
        challenge_creator_username

    FROM public.challenges
    JOIN public.users
    ON challenges.creator_id = users.id
    WHERE challenges.id = NEW.challenge_id;

    -- Loop through each user_id from the participant table
    FOR participant_record IN 
        SELECT bets.user_id, bets.amount, choices.is_correct, bets.created_at
        FROM public.choices
        JOIN public.bets ON bets.choice_id = choices.id
        WHERE choices.challenge_id = NEW.challenge_id
    LOOP
        IF participant_record.is_correct THEN
            notification_body := 'Vous avez gagné la partie!';
        ELSE
            notification_body := 'Vous avez perdu la partie...';
        END IF;
         -- Insert the notification
        INSERT INTO public.notifications (user_id, title, body, type, metadatas)
        VALUES (
            participant_record.user_id, 
            challenge_title, 
            notification_body, 
            'challenge_ended',
            jsonb_set(
                '{}'::jsonb,  -- Start with empty JSONB if null
                '{challenge_id}',                   -- JSON path to update
                to_jsonb(NEW.challenge_id::TEXT),       -- Value to insert
                true                                -- Create path if it does not exist
            )
        );

    END LOOP;

    IF challenge_has_bet
    THEN 

        SELECT COUNT(*) INTO participants_length
        FROM public.bets
        WHERE bets.choice_id = NEW.id;

        modulo := (challenge_amount % participants_length) != 0;
        amount_by_participant := FLOOR(challenge_amount / participants_length);

        -- Loop through each user_id from the participant who voted for this choice
        FOR bet_record IN 
            SELECT id, user_id
            FROM public.bets
            WHERE choice_id = NEW.id
            ORDER BY created_at ASC
        LOOP
            -- Insert the notification
            INSERT INTO public.transactions (receiver_id, origin_id, amount, status)
            VALUES (
                bet_record.user_id, 
                bet_record.id, 
                CASE 
                WHEN modulo = true THEN amount_by_participant + 1
                ELSE amount_by_participant
                END,
                'pending'
            );
            modulo := FALSE;
        END LOOP;
    END IF;

    RETURN NEW;
END;$$;


ALTER FUNCTION "public"."create_notif_challenge_ended"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."create_notif_challenge_invitation"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$DECLARE
    is_admin BOOLEAN;
    participant_username TEXT;
    challenge_title TEXT;
    challenge_creator_username TEXT;
BEGIN
    SELECT 
        challenges.title AS challenge_title,
        users.username AS creator_name
    INTO 
        challenge_title, 
        challenge_creator_username
    FROM public.challenges
    JOIN public.users
    ON challenges.creator_id = users.id
    WHERE challenges.id = NEW.challenge_id;

    -- Insert the notification
    INSERT INTO public.notifications (user_id, title, body, type, metadatas)
    VALUES (
        NEW.user_id, 
        challenge_title, 
        FORMAT('@%s Vous a invité à participer à un défi', challenge_creator_username), 
        'invitation',
        jsonb_set(
            '{}'::jsonb,  -- Start with empty JSONB if null
            '{challenge_id}',                   -- JSON path to update
            to_jsonb(NEW.challenge_id::TEXT),       -- Value to insert
            true                                -- Create path if it does not exist
        )
    );

    RETURN NEW;
END;$$;


ALTER FUNCTION "public"."create_notif_challenge_invitation"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."create_transaction_from_bet"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$DECLARE
    is_admin BOOLEAN;
BEGIN
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
END;$$;


ALTER FUNCTION "public"."create_transaction_from_bet"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."create_transaction_from_challenge"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$DECLARE
    is_admin BOOLEAN;
    participants_length INT;
    modulo BOOLEAN;
    amount_by_participant INT;
    participant_user_id UUID;
BEGIN
    SELECT COUNT(*) INTO participants_length
    FROM public.bets
    WHERE bets.choice_id = NEW.id;

    modulo := (NEW.amount % participants_length) != 0;
    amount_by_participant := FLOOR(NEW.amount / participants_length);

    -- Loop through each user_id from the participant who voted for this choice
    FOR participant_user_id IN 
        SELECT user_id 
        FROM public.bets
        WHERE choice_id = NEW.id
    LOOP
         -- Insert the notification
        INSERT INTO public.transactions (receiver_id, origin_id, amount, status)
        VALUES (
            participant_user_id, 
            NEW.challenge_id, 
            CASE 
              WHEN modulo == true THEN amount_by_participant + 1
              ELSE amount_by_participant
            END,
            'pending'
        );
        modulo := FALSE;
    END LOOP;

    RETURN NEW;
END;$$;


ALTER FUNCTION "public"."create_transaction_from_challenge"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."handle_new_user"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$DECLARE 
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
  values (new.id, 500);

  return new;
end;$$;


ALTER FUNCTION "public"."handle_new_user"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."handle_update_user"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$BEGIN
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
END;$$;


ALTER FUNCTION "public"."handle_update_user"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."is_auth_user_challenge_creator"("_challenge_id" "uuid") RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$DECLARE 
  challenge_count int;

BEGIN
  RAISE LOG 'Is % the creator of %', auth.uid(), _challenge_id;
  
  SELECT COUNT(*) INTO challenge_count    
  FROM challenges
  WHERE challenges.id = _challenge_id AND challenges.creator_id = auth.uid();
  
  RAISE LOG 'There is % challenges table', challenge_count;

  RETURN challenge_count > 0;
END;$$;


ALTER FUNCTION "public"."is_auth_user_challenge_creator"("_challenge_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."is_auth_user_friend_to_user_id"("_user_id" "uuid") RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$BEGIN
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
END;$$;


ALTER FUNCTION "public"."is_auth_user_friend_to_user_id"("_user_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."is_auth_user_participant_to_challenge"("_challenge_id" "uuid") RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$BEGIN
  RETURN EXISTS(
    SELECT 1
    FROM public.participants
    WHERE (
      participants.user_id = auth.uid()
      AND participants.challenge_id = _challenge_id
    )
  );
END;$$;


ALTER FUNCTION "public"."is_auth_user_participant_to_challenge"("_challenge_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."make_transaction"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$DECLARE
  is_admin BOOLEAN;
  challenge_id UUID;
  user_wallet_new_value INT;
  challenge_amount_new_value INT;
BEGIN

  IF NEW.origin_id IS NULL THEN
    RAISE EXCEPTION 'No bet origin for this transaction';
  END IF;

  -- Get the challenge corresponding
    SELECT 
      choices.challenge_id AS challenge_id,
      bets.id as bet_id
    INTO challenge_id
    FROM public.bets
    JOIN public.choices
    ON bets.choice_id = choices.id
    WHERE bets.id = NEW.origin_id;

  -- If there is a sender
  IF (NEW.sender_id IS NOT NULL)
    AND (NEW.receiver_id IS NULL)
  THEN
    -- Set the amount to the challenge
    UPDATE public.challenges
    SET amount = amount + NEW.amount
    WHERE challenges.id = challenge_id;

    -- Remove the value from the user wallet
    UPDATE public.wallets
    SET amount = amount - NEW.amount
    WHERE wallets.user_id = NEW.sender_id
    RETURNING amount INTO user_wallet_new_value;

    IF user_wallet_new_value < 0 THEN
      RAISE EXCEPTION 'The user has not enought money in his wallet (%) for this transaction', user_wallet_new_value;
    END IF;

    -- Update the bet status
    UPDATE public.bets
    SET status = 'done'
    WHERE bets.id = NEW.origin_id;

  END IF;

   -- If there is a sender
  IF (NEW.sender_id IS NULL)
    AND (NEW.receiver_id IS NOT NULL)
  THEN
    -- Remove the amount to the challenge
    UPDATE public.challenges
    SET amount = amount - NEW.amount
    WHERE challenges.id = challenge_id
    RETURNING amount INTO challenge_amount_new_value;

    -- Add the value from the user wallet
    UPDATE public.wallets
    SET amount = amount + NEW.amount
    WHERE wallets.user_id = NEW.receiver_id;

    IF user_wallet_new_value < 0 THEN
      RAISE EXCEPTION 'The challenge has not enought money (%) for this transaction', challenge_amount_new_value;
    END IF;

  END IF;

  -- Update transaction to done
  UPDATE public.transactions
  SET status = 'done'
  WHERE transactions.id = NEW.id;

  RETURN NEW;
END;$$;


ALTER FUNCTION "public"."make_transaction"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."on_challenge_end_wrapper"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$BEGIN
    PERFORM create_notif_challenge_ended(NEW);
    PERFORM create_transaction_from_challenge(NEW);

    RETURN NEW;
END;$$;


ALTER FUNCTION "public"."on_challenge_end_wrapper"() OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."bets" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "choice_id" "uuid" NOT NULL,
    "user_id" "uuid" NOT NULL,
    "amount" bigint,
    "status" "public"."bet_status" DEFAULT 'pending'::"public"."bet_status" NOT NULL
);


ALTER TABLE "public"."bets" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."challenges" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "title" "text" NOT NULL,
    "question" "text" NOT NULL,
    "starting" timestamp without time zone NOT NULL,
    "ending" timestamp without time zone NOT NULL,
    "creator_id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "limit_date" timestamp with time zone NOT NULL,
    "has_bet" boolean DEFAULT true NOT NULL,
    "min_bet" bigint,
    "max_bet" bigint,
    "amount" bigint DEFAULT '0'::bigint NOT NULL
);


ALTER TABLE "public"."challenges" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."choices" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "challenge_id" "uuid" NOT NULL,
    "value" "text" NOT NULL,
    "is_correct" boolean DEFAULT false NOT NULL
);


ALTER TABLE "public"."choices" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."friendships" (
    "sender_id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "receiver_id" "uuid" NOT NULL
);


ALTER TABLE "public"."friendships" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."notifications" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "title" "text" NOT NULL,
    "body" "text",
    "status" "public"."notification_status" DEFAULT 'pending'::"public"."notification_status" NOT NULL,
    "type" "public"."notification_type" NOT NULL,
    "metadatas" "jsonb" DEFAULT '{}'::"jsonb" NOT NULL
);


ALTER TABLE "public"."notifications" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."participants" (
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "user_id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "challenge_id" "uuid" NOT NULL,
    "status" "public"."participation_status" DEFAULT 'pending'::"public"."participation_status"
);


ALTER TABLE "public"."participants" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."transactions" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "sender_id" "uuid",
    "receiver_id" "uuid",
    "amount" bigint NOT NULL,
    "origin_id" "uuid",
    "status" "public"."transaction_status" DEFAULT 'pending'::"public"."transaction_status" NOT NULL
);


ALTER TABLE "public"."transactions" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."users" (
    "id" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "email" "text",
    "username" "text",
    "avatar_url" "text",
    "full_name" "text",
    "push_token" "text"
);


ALTER TABLE "public"."users" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."wallets" (
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "amount" bigint DEFAULT '0'::bigint NOT NULL
);


ALTER TABLE "public"."wallets" OWNER TO "postgres";


ALTER TABLE ONLY "public"."bets"
    ADD CONSTRAINT "bets_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."challenges"
    ADD CONSTRAINT "challenges_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."choices"
    ADD CONSTRAINT "choices_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."friendships"
    ADD CONSTRAINT "friendships_pkey" PRIMARY KEY ("sender_id", "receiver_id");



ALTER TABLE ONLY "public"."notifications"
    ADD CONSTRAINT "notifications_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."participants"
    ADD CONSTRAINT "participants_pkey" PRIMARY KEY ("user_id", "challenge_id");



ALTER TABLE ONLY "public"."transactions"
    ADD CONSTRAINT "transactions_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."wallets"
    ADD CONSTRAINT "wallets_pkey" PRIMARY KEY ("user_id");



CREATE OR REPLACE TRIGGER "on_choice_update" AFTER UPDATE ON "public"."choices" FOR EACH ROW WHEN ((("new"."is_correct" = true) AND ("old"."is_correct" IS DISTINCT FROM "new"."is_correct"))) EXECUTE FUNCTION "public"."create_notif_challenge_ended"();



CREATE OR REPLACE TRIGGER "on_new_bet" AFTER INSERT ON "public"."bets" FOR EACH ROW EXECUTE FUNCTION "public"."create_transaction_from_bet"();



CREATE OR REPLACE TRIGGER "on_new_transaction" AFTER INSERT ON "public"."transactions" FOR EACH ROW EXECUTE FUNCTION "public"."make_transaction"();



CREATE OR REPLACE TRIGGER "on_notification_insert" AFTER INSERT ON "public"."notifications" FOR EACH ROW EXECUTE FUNCTION "public"."call_edge_function"('/functions/v1/send-notification', 'POST', '{"Content-type":"application/json","x-supabase-webhook-source":"whatever"}', '{}', '5000');



CREATE OR REPLACE TRIGGER "on_participant_insert" AFTER INSERT ON "public"."participants" FOR EACH ROW EXECUTE FUNCTION "public"."create_notif_challenge_invitation"();



ALTER TABLE ONLY "public"."bets"
    ADD CONSTRAINT "bets_choice_id_fkey" FOREIGN KEY ("choice_id") REFERENCES "public"."choices"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."bets"
    ADD CONSTRAINT "bets_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."challenges"
    ADD CONSTRAINT "challenges_creator_id_fkey" FOREIGN KEY ("creator_id") REFERENCES "public"."users"("id") ON UPDATE CASCADE ON DELETE SET DEFAULT;



ALTER TABLE ONLY "public"."choices"
    ADD CONSTRAINT "choices_challenge_id_fkey" FOREIGN KEY ("challenge_id") REFERENCES "public"."challenges"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."friendships"
    ADD CONSTRAINT "friendships_receiver_id_fkey" FOREIGN KEY ("receiver_id") REFERENCES "public"."users"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."friendships"
    ADD CONSTRAINT "friendships_sender_id_fkey" FOREIGN KEY ("sender_id") REFERENCES "public"."users"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."notifications"
    ADD CONSTRAINT "notifications_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."participants"
    ADD CONSTRAINT "participants_challenge_id_fkey" FOREIGN KEY ("challenge_id") REFERENCES "public"."challenges"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."participants"
    ADD CONSTRAINT "participants_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."transactions"
    ADD CONSTRAINT "transactions_origin_id_fkey" FOREIGN KEY ("origin_id") REFERENCES "public"."bets"("id") ON UPDATE CASCADE ON DELETE SET NULL;



ALTER TABLE ONLY "public"."transactions"
    ADD CONSTRAINT "transactions_receiver_id_fkey" FOREIGN KEY ("receiver_id") REFERENCES "public"."users"("id") ON UPDATE CASCADE ON DELETE SET DEFAULT;



ALTER TABLE ONLY "public"."transactions"
    ADD CONSTRAINT "transactions_sender_id_fkey" FOREIGN KEY ("sender_id") REFERENCES "public"."users"("id") ON UPDATE CASCADE ON DELETE SET DEFAULT;



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_id_fkey" FOREIGN KEY ("id") REFERENCES "auth"."users"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."wallets"
    ADD CONSTRAINT "wallets_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON UPDATE CASCADE ON DELETE CASCADE;



CREATE POLICY "Allow ALL to creator " ON "public"."challenges" TO "authenticated" USING (("creator_id" = "auth"."uid"()));



CREATE POLICY "Allow ALL to own user" ON "public"."bets" TO "authenticated" USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Allow ALL to own user" ON "public"."friendships" TO "authenticated" USING ((("auth"."uid"() = "sender_id") OR ("auth"."uid"() = "receiver_id")));



CREATE POLICY "Allow ALL to own user" ON "public"."notifications" TO "authenticated" USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Allow DELETE to challenge creator" ON "public"."choices" FOR DELETE TO "authenticated" USING ("public"."is_auth_user_challenge_creator"("challenge_id"));



CREATE POLICY "Allow DELETE to challenge creator" ON "public"."participants" FOR DELETE TO "authenticated" USING ("public"."is_auth_user_challenge_creator"("challenge_id"));



CREATE POLICY "Allow INSERT to challenge creator" ON "public"."choices" FOR INSERT TO "authenticated" WITH CHECK ("public"."is_auth_user_challenge_creator"("challenge_id"));



CREATE POLICY "Allow INSERT to challenge creator" ON "public"."participants" FOR INSERT TO "authenticated" WITH CHECK ("public"."is_auth_user_challenge_creator"("challenge_id"));



CREATE POLICY "Allow SELECT own user" ON "public"."wallets" FOR SELECT TO "authenticated" USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Allow SELECT to challenge participants" ON "public"."choices" FOR SELECT USING (("public"."is_auth_user_challenge_creator"("challenge_id") OR "public"."is_auth_user_participant_to_challenge"("challenge_id")));



CREATE POLICY "Allow SELECT to challenge participants" ON "public"."participants" FOR SELECT TO "authenticated" USING ((("auth"."uid"() = "user_id") OR "public"."is_auth_user_participant_to_challenge"("challenge_id")));



CREATE POLICY "Allow SELECT to own or friends users" ON "public"."users" FOR SELECT TO "authenticated" USING ((("auth"."uid"() = "id") OR "public"."is_auth_user_friend_to_user_id"("id")));



CREATE POLICY "Allow SELECT to own user" ON "public"."transactions" FOR SELECT TO "authenticated" USING ((("auth"."uid"() = "sender_id") OR ("auth"."uid"() = "receiver_id")));



CREATE POLICY "Allow UPDATE to challenge creator" ON "public"."choices" FOR UPDATE TO "authenticated" USING ("public"."is_auth_user_challenge_creator"("challenge_id"));



CREATE POLICY "Allow UPDATE to challenge creator" ON "public"."participants" FOR UPDATE TO "authenticated" USING ("public"."is_auth_user_challenge_creator"("challenge_id"));



ALTER TABLE "public"."bets" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."challenges" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."choices" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."friendships" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."notifications" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."participants" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."transactions" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."users" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."wallets" ENABLE ROW LEVEL SECURITY;


CREATE PUBLICATION "powersync" WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION "powersync" OWNER TO "postgres";




ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";


ALTER PUBLICATION "powersync" ADD TABLE ONLY "public"."bets";



ALTER PUBLICATION "powersync" ADD TABLE ONLY "public"."challenges";



ALTER PUBLICATION "powersync" ADD TABLE ONLY "public"."choices";



ALTER PUBLICATION "powersync" ADD TABLE ONLY "public"."friendships";



ALTER PUBLICATION "powersync" ADD TABLE ONLY "public"."notifications";



ALTER PUBLICATION "powersync" ADD TABLE ONLY "public"."participants";



ALTER PUBLICATION "powersync" ADD TABLE ONLY "public"."transactions";



ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."users";



ALTER PUBLICATION "powersync" ADD TABLE ONLY "public"."users";



ALTER PUBLICATION "powersync" ADD TABLE ONLY "public"."wallets";









GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";























































































































































































































































































































































































GRANT ALL ON FUNCTION "public"."call_edge_function"() TO "anon";
GRANT ALL ON FUNCTION "public"."call_edge_function"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."call_edge_function"() TO "service_role";



GRANT ALL ON FUNCTION "public"."create_notif_challenge_ended"() TO "anon";
GRANT ALL ON FUNCTION "public"."create_notif_challenge_ended"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."create_notif_challenge_ended"() TO "service_role";



GRANT ALL ON FUNCTION "public"."create_notif_challenge_invitation"() TO "anon";
GRANT ALL ON FUNCTION "public"."create_notif_challenge_invitation"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."create_notif_challenge_invitation"() TO "service_role";



GRANT ALL ON FUNCTION "public"."create_transaction_from_bet"() TO "anon";
GRANT ALL ON FUNCTION "public"."create_transaction_from_bet"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."create_transaction_from_bet"() TO "service_role";



GRANT ALL ON FUNCTION "public"."create_transaction_from_challenge"() TO "anon";
GRANT ALL ON FUNCTION "public"."create_transaction_from_challenge"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."create_transaction_from_challenge"() TO "service_role";



GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "anon";
GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "service_role";



GRANT ALL ON FUNCTION "public"."handle_update_user"() TO "anon";
GRANT ALL ON FUNCTION "public"."handle_update_user"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."handle_update_user"() TO "service_role";



GRANT ALL ON FUNCTION "public"."is_auth_user_challenge_creator"("_challenge_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."is_auth_user_challenge_creator"("_challenge_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."is_auth_user_challenge_creator"("_challenge_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."is_auth_user_friend_to_user_id"("_user_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."is_auth_user_friend_to_user_id"("_user_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."is_auth_user_friend_to_user_id"("_user_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."is_auth_user_participant_to_challenge"("_challenge_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."is_auth_user_participant_to_challenge"("_challenge_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."is_auth_user_participant_to_challenge"("_challenge_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."make_transaction"() TO "anon";
GRANT ALL ON FUNCTION "public"."make_transaction"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."make_transaction"() TO "service_role";



GRANT ALL ON FUNCTION "public"."on_challenge_end_wrapper"() TO "anon";
GRANT ALL ON FUNCTION "public"."on_challenge_end_wrapper"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."on_challenge_end_wrapper"() TO "service_role";



























GRANT ALL ON TABLE "public"."bets" TO "anon";
GRANT ALL ON TABLE "public"."bets" TO "authenticated";
GRANT ALL ON TABLE "public"."bets" TO "service_role";



GRANT ALL ON TABLE "public"."challenges" TO "anon";
GRANT ALL ON TABLE "public"."challenges" TO "authenticated";
GRANT ALL ON TABLE "public"."challenges" TO "service_role";



GRANT ALL ON TABLE "public"."choices" TO "anon";
GRANT ALL ON TABLE "public"."choices" TO "authenticated";
GRANT ALL ON TABLE "public"."choices" TO "service_role";



GRANT ALL ON TABLE "public"."friendships" TO "anon";
GRANT ALL ON TABLE "public"."friendships" TO "authenticated";
GRANT ALL ON TABLE "public"."friendships" TO "service_role";



GRANT ALL ON TABLE "public"."notifications" TO "anon";
GRANT ALL ON TABLE "public"."notifications" TO "authenticated";
GRANT ALL ON TABLE "public"."notifications" TO "service_role";



GRANT ALL ON TABLE "public"."participants" TO "anon";
GRANT ALL ON TABLE "public"."participants" TO "authenticated";
GRANT ALL ON TABLE "public"."participants" TO "service_role";



GRANT ALL ON TABLE "public"."transactions" TO "anon";
GRANT ALL ON TABLE "public"."transactions" TO "authenticated";
GRANT ALL ON TABLE "public"."transactions" TO "service_role";



GRANT ALL ON TABLE "public"."users" TO "anon";
GRANT ALL ON TABLE "public"."users" TO "authenticated";
GRANT ALL ON TABLE "public"."users" TO "service_role";



GRANT ALL ON TABLE "public"."wallets" TO "anon";
GRANT ALL ON TABLE "public"."wallets" TO "authenticated";
GRANT ALL ON TABLE "public"."wallets" TO "service_role";



ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "service_role";






























RESET ALL;
