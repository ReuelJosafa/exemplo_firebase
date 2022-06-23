import 'dart:async';

import 'package:exemplo_firebase/modules/login/login_page.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../../shared/services/custom_firebase_auth.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  CustomFirebaseAuth storeAuth = CustomFirebaseAuth();

  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    isEmailVerified = storeAuth.wasEmailVerified;

    if (!isEmailVerified) {
      _sendVeriEmail();

      timer = Timer.periodic(const Duration(seconds: 3), (_) {
        checkEmailVerified();
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) =>
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const MyHomePage())));
    }
  }

  Future<void> _sendVeriEmail() async {
    try {
      // print("FEZ UMA TENTATIVA");
      await storeAuth.sendVerificationEmail();

      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 10));
      if (!isEmailVerified) {
        setState(() => canResendEmail = true);
      }
    } on AuthException catch (e) {
      setState(() => canResendEmail = false);

      // print(e);
      var snackBar = SnackBar(
        width: 344,
        behavior: SnackBarBehavior.floating,
        // margin: const EdgeInsets.all(8),
        elevation: 1,
        content: Text(e.message),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      await Future.delayed(const Duration(minutes: 1));
      if (!isEmailVerified) {
        setState(() => canResendEmail = true);
      }
    }
  }

  Future<void> checkEmailVerified() async {
    await storeAuth.reloadUser();

    setState(() {
      isEmailVerified = storeAuth.wasEmailVerified;
    });

    if (isEmailVerified) {
      timer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    // widge
    if (isEmailVerified) {
      WidgetsBinding.instance.addPostFrameCallback((_) =>
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const MyHomePage())));
      // return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Verificar email')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Color(0xFF0199A4),
            Color.fromRGBO(255, 188, 117, 0.9),
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        // padding: MediaQuery.of(context).viewInsets.copyWith(left: 32, right: 32),
        padding: const EdgeInsets.only(left: 32, right: 32),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Foi enviada uma verificação de email para ${storeAuth.userEmail}.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 26,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.white, thickness: 1.5),
              const SizedBox(height: 16),
              const Text(
                  'Para que você tenha acesso ao aplicativo, certifique-se de checar o seu email!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w400)),
              const SizedBox(height: 32),
              const Text(
                '* Caso não tenha encontrado, verifique a caixa de spam.',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w300),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                icon: const Icon(Icons.email),
                onPressed: canResendEmail
                    ? () async {
                        await _sendVeriEmail();
                      }
                    : null,
                label: const Text('Reenviar email'),
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50)),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  timer?.cancel();

                  await storeAuth.logout();

                  if (!mounted) return;
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    minimumSize: const Size.fromHeight(50)),
                child: const Text('CANCELAR'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
