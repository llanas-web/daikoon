

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






CREATE EXTENSION IF NOT EXISTS "pgsodium" WITH SCHEMA "pgsodium";






COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";






CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgjwt" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";


create type "public"."transaction_status" as enum ('pending', 'done');

ALTER TYPE "public"."transaction_status" OWNER TO "postgres";



CREATE TYPE "public"."participation_status" AS ENUM (
    'accepted',
    'declined',
    'pending'
);


ALTER TYPE "public"."participation_status" OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."handle_new_user"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
declare is_admin boolean;
begin
  
  insert into public.users (id, email, username)
  values (new.id, new.email, split_part(new.email, '@', 1));
  
  insert into public.wallets (user_id, amount)
  values (new.id, 100);
  return new;

end;
$$;


ALTER FUNCTION "public"."handle_new_user"() OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."users" (
    "id" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "email" "text",
    "username" "text",
    "avatar_url" "text",
    "fcm_token" "text"
);


ALTER TABLE "public"."users" OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."push_friends"("user_id" "uuid", "friend_id" "uuid") RETURNS "public"."users"
    LANGUAGE "sql"
    AS $$
  update public.users
  set friends = array_append(friends, friend_id)
  where id = user_id
  returning *;
$$;


ALTER FUNCTION "public"."push_friends"("user_id" "uuid", "friend_id" "uuid") OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."bets" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "choice_id" "uuid" NOT NULL,
    "user_id" "uuid" NOT NULL,
    "amount" bigint
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
    "limit_date" timestamp with time zone
);


ALTER TABLE "public"."challenges" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."choices" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "challenge_id" "uuid" NOT NULL,
    "value" "text" NOT NULL,
    "is_correct" boolean
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
    "user_id" "uuid",
    "challenge_id" "uuid",
    "title" "text",
    "body" "text",
    "is_checked" boolean
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
    "status" "public"."transaction_status" DEFAULT 'pending'::"public"."transaction_status",
    "sender_id" "uuid" NOT NULL,
    "receiver_id" "uuid" NOT NULL,
    "amount" bigint NOT NULL,
    "origin_id" "uuid"
);


ALTER TABLE "public"."transactions" OWNER TO "postgres";


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
    ADD CONSTRAINT "users_fcm_token_key" UNIQUE ("fcm_token");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_pkey" PRIMARY KEY ("id");



CREATE OR REPLACE TRIGGER "on-challenge-end" AFTER UPDATE ON "public"."choices" FOR EACH ROW EXECUTE FUNCTION "supabase_functions"."http_request"('https://fxddwscslzkawstukmyl.supabase.co/functions/v1/challenge-ended', 'POST', '{"Content-type":"application/json","Authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ4ZGR3c2NzbHprYXdzdHVrbXlsIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTcwNzMwNDQzNywiZXhwIjoyMDIyODgwNDM3fQ.eGGBb2JZWEeJ5z7JW4tEJhSimDKhZocKpScPdvI1zpY"}', '{}', '1000');



CREATE OR REPLACE TRIGGER "on-participant-insert" AFTER INSERT ON "public"."participants" FOR EACH ROW EXECUTE FUNCTION "supabase_functions"."http_request"('https://fxddwscslzkawstukmyl.supabase.co/functions/v1/challenge-invitation', 'POST', '{"Content-type":"application/json","Authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ4ZGR3c2NzbHprYXdzdHVrbXlsIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTcwNzMwNDQzNywiZXhwIjoyMDIyODgwNDM3fQ.eGGBb2JZWEeJ5z7JW4tEJhSimDKhZocKpScPdvI1zpY"}', '{}', '1000');



ALTER TABLE ONLY "public"."bets"
    ADD CONSTRAINT "bets_choice_id_fkey" FOREIGN KEY ("choice_id") REFERENCES "public"."choices"("id");



ALTER TABLE ONLY "public"."bets"
    ADD CONSTRAINT "bets_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id");



ALTER TABLE ONLY "public"."challenges"
    ADD CONSTRAINT "challenges_creator_id_fkey" FOREIGN KEY ("creator_id") REFERENCES "public"."users"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."choices"
    ADD CONSTRAINT "choices_challenge_id_fkey" FOREIGN KEY ("challenge_id") REFERENCES "public"."challenges"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."friendships"
    ADD CONSTRAINT "friendships_receiver_id_fkey" FOREIGN KEY ("receiver_id") REFERENCES "public"."users"("id");



ALTER TABLE ONLY "public"."friendships"
    ADD CONSTRAINT "friendships_sender_id_fkey" FOREIGN KEY ("sender_id") REFERENCES "public"."users"("id");



ALTER TABLE ONLY "public"."notifications"
    ADD CONSTRAINT "notifications_challenge_id_fkey" FOREIGN KEY ("challenge_id") REFERENCES "public"."challenges"("id");



ALTER TABLE ONLY "public"."notifications"
    ADD CONSTRAINT "notifications_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id");



ALTER TABLE ONLY "public"."participants"
    ADD CONSTRAINT "participants_challenge_id_fkey" FOREIGN KEY ("challenge_id") REFERENCES "public"."challenges"("id");



ALTER TABLE ONLY "public"."participants"
    ADD CONSTRAINT "participants_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."friendships"
    ADD CONSTRAINT "relationship_user_asked_fkey" FOREIGN KEY ("receiver_id") REFERENCES "public"."users"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."friendships"
    ADD CONSTRAINT "relationship_user_id_fkey" FOREIGN KEY ("sender_id") REFERENCES "public"."users"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."transactions"
    ADD CONSTRAINT "transactions_origin_id_fkey" FOREIGN KEY ("origin_id") REFERENCES "public"."bets"("id");



ALTER TABLE ONLY "public"."transactions"
    ADD CONSTRAINT "transactions_receiver_id_fkey" FOREIGN KEY ("receiver_id") REFERENCES "public"."users"("id");



ALTER TABLE ONLY "public"."transactions"
    ADD CONSTRAINT "transactions_sender_id_fkey" FOREIGN KEY ("sender_id") REFERENCES "public"."users"("id");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_id_fkey" FOREIGN KEY ("id") REFERENCES "auth"."users"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."wallets"
    ADD CONSTRAINT "wallets_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id");





ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";


ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."users";









GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";





















































































































































































































GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "anon";
GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "service_role";



GRANT ALL ON TABLE "public"."users" TO "anon";
GRANT ALL ON TABLE "public"."users" TO "authenticated";
GRANT ALL ON TABLE "public"."users" TO "service_role";



GRANT ALL ON FUNCTION "public"."push_friends"("user_id" "uuid", "friend_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."push_friends"("user_id" "uuid", "friend_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."push_friends"("user_id" "uuid", "friend_id" "uuid") TO "service_role";
























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
