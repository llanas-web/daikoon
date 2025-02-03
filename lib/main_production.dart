import 'package:daikoon/app/app.dart';
import 'package:daikoon/bootstrap.dart';
import 'package:daikoon/firebase_options_prod.dart';
import 'package:shared/shared.dart';

void main() {
  bootstrap(
    (powerSyncrepository) => const App(),
    options: DefaultFirebaseOptions.currentPlatform,
    appFlavor: AppFlavor.production(),
  );
}
