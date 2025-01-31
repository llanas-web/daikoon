drop trigger if exists "on_notification_insert" on "public"."notifications";

alter table "public"."transactions" drop constraint "transactions_origin_id_fkey";

alter table "public"."transactions" add constraint "transactions_origin_id_fkey" FOREIGN KEY (origin_id) REFERENCES bets(id) ON DELETE SET NULL not valid;

alter table "public"."transactions" validate constraint "transactions_origin_id_fkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.create_notif_challenge_ended()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$DECLARE
    is_admin BOOLEAN;
    -- notification variable
    participant_record RECORD;
    challenge_title TEXT;
    challenge_creator_username TEXT;
    -- transaction variable
    bet_record RECORD;
    participants_length INT;
    modulo BOOLEAN;
    challenge_amount INT;
    amount_by_participant INT;
BEGIN
    SELECT 
        challenges.title AS challenge_title,
        challenges.amount AS challenge_amount,
        users.username AS creator_name
    INTO 
        challenge_title, 
        challenge_amount,
        challenge_creator_username
    FROM public.challenges
    JOIN public.users
    ON challenges.creator_id = users.id
    WHERE challenges.id = NEW.challenge_id;

    -- Loop through each user_id from the participant table
    FOR participant_record IN 
        SELECT user_id 
        FROM public.participants
        WHERE challenge_id = NEW.challenge_id
    LOOP
         -- Insert the notification
        INSERT INTO public.notifications (user_id, title, body, type, metadatas)
        VALUES (
            participant_record.user_id, 
            challenge_title, 
            FORMAT('%s has declared a winner! See if you have win!', challenge_creator_username), 
            'challenge_ended',
            jsonb_set(
                '{}'::jsonb,  -- Start with empty JSONB if null
                '{challenge_id}',                   -- JSON path to update
                to_jsonb(NEW.challenge_id::TEXT),       -- Value to insert
                true                                -- Create path if it does not exist
            )
        );

    END LOOP;

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

    RETURN NEW;
END;$function$
;

CREATE TRIGGER on_notification_insert AFTER INSERT ON public.notifications FOR EACH ROW EXECUTE FUNCTION supabase_functions.http_request('http://host.docker.internal:54321/functions/v1/send-notification', 'POST', '{"Content-type":"application/json","Authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0"}', '{}', '5000');

alter table "public"."challenges" alter column "limit_date" set not null;

alter table "public"."notifications" alter column "title" set not null;

alter table "public"."notifications" alter column "type" set not null;

alter table "public"."notifications" alter column "user_id" set not null;

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.call_edge_function()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'supabase_functions'
AS $function$
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
$function$
;
