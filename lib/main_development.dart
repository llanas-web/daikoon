import 'package:daikoon/app/app.dart';
import 'package:daikoon/bootstrap.dart';
import 'package:daikoon/firebase_options_dev.dart';

void main() {
  bootstrap(
    (powerSyncrepository) => const App(),
    options: DefaultFirebaseOptions.currentPlatform,
    isDev: true,
  );
}
