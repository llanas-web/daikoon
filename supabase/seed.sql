SELECT vault.create_secret(
    'http://host.docker.internal:54321', 
    'supabase_project_url', 
    'URL to be used for calling edge functions, this is set here because we want to develop edge functions with webhohks from database triggers in multiple environments'
);