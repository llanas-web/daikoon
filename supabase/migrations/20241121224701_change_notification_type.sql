alter type "public"."notification_type" rename to "notification_type__old_version_to_be_dropped";

create type "public"."notification_type" as enum ('invitation', 'challenge_ended', 'new_message');

alter table "public"."notifications" alter column type type "public"."notification_type" using type::text::"public"."notification_type";

drop type "public"."notification_type__old_version_to_be_dropped";


