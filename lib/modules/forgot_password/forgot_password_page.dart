import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../../shared/services/custom_firebase_auth.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  CustomFirebaseAuth storeAuth = CustomFirebaseAuth();

  String email = '';
  final emailFocus = FocusNode();
  final formKey = GlobalKey<FormState>();

  void onChangeEmail(String value) => email = value;

  String? emailValidator(String? email) {
    if (email == null || email.trim().isEmpty) {
      return 'Por favor, preencha o email!';
    } else if (!EmailValidator.validate(email)) {
      return 'Não é um email válido!';
    }
    return null;
  }

  Future<void> submitForm() async {
    bool isValidated = formKey.currentState?.validate() ?? false;
    if (!isValidated) {
      return;
    }
    // print('Vai tentar recuperar $email');
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => Center(
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(16),
                height: 80,
                width: 80,
                child: const CircularProgressIndicator())));
    try {
      await storeAuth.recoverPassword(email);

      if (!mounted) return;
      var snackBar = const SnackBar(
        width: 344,
        behavior: SnackBarBehavior.floating,
        elevation: 1,
        content: Text('O email de recuperação foi enviado'),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Navigator.of(context).popUntil((route) => route.isFirst);
    } on AuthException catch (e) {
      var snackBar = SnackBar(
        width: 344,
        behavior: SnackBarBehavior.floating,
        elevation: 1,
        content: Text(e.message),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).pop();
    }
    formKey.currentState?.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recupere sua senha')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Color(0xFF0199A4),
            Color.fromRGBO(255, 188, 117, 0.9),
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        padding: const EdgeInsets.only(left: 32, right: 32),
        alignment: Alignment.center,
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                const Text(
                  'Receba um email para resetar sua senha.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                const Text(
                  '* Caso não tenha encontrado, verifique a caixa de spam.',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w300),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: onChangeEmail,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.email),
                      hintText: 'Digite seu email aqui...'),
                  autovalidateMode: AutovalidateMode.disabled,
                  focusNode: emailFocus,
                  textInputAction: TextInputAction.next,
                  validator: emailValidator,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50)),
                  onPressed: submitForm,
                  child: const Text('RECUPERAR'),
                ),
                const SizedBox(height: 16),
              ])),
        ),
      ),
    );
  }
}
