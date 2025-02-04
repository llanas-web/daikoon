SELECT vault.create_secret(
    'http://host.docker.internal:54321', 
    'supabase_project_url', 
    'URL to be used for calling edge functions, this is set here because we want to develop edge functions with webhohks from database triggers in multiple environments'
);

drop publication if exists powersync;
create publication powersync for table public.wallets, public.users, public.transactions, public.participants, public.notifications, public.friendships, public.choices, public.challenges, public.bets;