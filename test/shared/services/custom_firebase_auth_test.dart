import 'package:exemplo_firebase/firebase_options.dart';
import 'package:exemplo_firebase/shared/services/custom_firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  CustomFirebaseAuth storeAuth = CustomFirebaseAuth();

  testWidgets('custom firebase auth ...', (tester) async {
    await storeAuth.login('@', '123');

    // expect(storeAuth.isAuthenticated, false);
  });
}
