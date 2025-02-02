// ignore_for_file: public_member_api_docs

enum Env {
  supabaseUrl('SUPABASE_URL'),
  supabaseAnonKey('SUPABASE_ANON_KEY'),
  powerSyncUrl('POWERSYNC_URL'),
  iOSClientId('IOS_CLIENT_ID'),
  webClientId('WEB_CLIENT_ID'),
  ;

  const Env(this.value);

  final String value;
}
