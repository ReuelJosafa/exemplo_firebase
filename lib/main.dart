import 'package:exemplo_firebase/firebase_options.dart';
import 'package:exemplo_firebase/modules/login/login_page.dart';
import 'package:exemplo_firebase/modules/verify_email/verify_email_page.dart';
import 'package:exemplo_firebase/shared/services/custom_firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  CustomFirebaseAuth storeAuth = CustomFirebaseAuth();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          colorScheme: const ColorScheme.light(primary: Color(0xFF0199A4)),
          appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF0199A4)),
          primaryColor: const Color(0xFF0199A4),
          buttonTheme: const ButtonThemeData(
              buttonColor: Color.fromRGBO(255, 188, 117, 0.9))),
      home: !storeAuth.isAuthenticated
          ? const LoginPage()
          : const VerifyEmailPage(),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title = 'Flutter Demo Home Page'})
      : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CustomFirebaseAuth storeAuth = CustomFirebaseAuth();
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () async {
                await storeAuth.logout();
                if (!mounted) return;
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );

    /* StreamBuilder(builder: ((context, snapshot) {
      if (snapshot.hasData) {
        return _homePage();
      } else {
        return Ver
      }
    })); */
  }
}
