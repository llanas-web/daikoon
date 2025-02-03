// ignore_for_file: public_member_api_docs

import 'package:env/env.dart';

enum Flavor {
  development,
  production,
}

sealed class AppEnv {
  const AppEnv();

  String getEnv(Env env);
}

class AppFlavor extends AppEnv {
  const AppFlavor._({required this.flavor});

  factory AppFlavor.development() =>
      const AppFlavor._(flavor: Flavor.development);

  factory AppFlavor.production() =>
      const AppFlavor._(flavor: Flavor.production);

  final Flavor flavor;

  @override
  String getEnv(Env env) => switch (env) {
        Env.supabaseUrl => flavor == Flavor.development
            ? EnvDev.supabaseUrl
            : EnvProd.supabaseUrl,
        Env.supabaseAnonKey => flavor == Flavor.development
            ? EnvDev.supabaseAnonKey
            : EnvProd.supabaseAnonKey,
        Env.powerSyncUrl => flavor == Flavor.development
            ? EnvDev.powersyncUrl
            : EnvProd.powersyncUrl,
        Env.iOSClientId => flavor == Flavor.development
            ? EnvDev.iOSClientId
            : EnvProd.iOSClientId,
        Env.webClientId => flavor == Flavor.development
            ? EnvDev.webClientId
            : EnvProd.webClientId,
      };
}
