import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../../shared/services/custom_firebase_auth.dart';

class LoginPage extends StatefulWidget {
  ///'/login'
  static const String id = '/login';
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  CustomFirebaseAuth storeAuth = CustomFirebaseAuth();

  final formKey = GlobalKey<FormState>();
  bool obscureText = true;
  String passwordConfirm = '';
  String email = '';
  String? erro;

  final emailFocus = FocusNode();
  final senhaFocus = FocusNode();

  IconData get passwordSufixIcon {
    return obscureText ? Icons.visibility : Icons.visibility_off;
  }

  void changeObscureText() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  void onChangePassword(String value) => passwordConfirm = value;

  void onChangeEmail(String value) => email = value;

  String? emailValidator(String? email) {
    if (email == null || email.trim().isEmpty) {
      return 'Por favor, preencha o email!';
    } else if (!EmailValidator.validate(email)) {
      return 'Não é um email válido!';
    }
    return null;
  }

  String? passwordValidator(String? password) {
    if (password!.length < 6) {
      return 'A senha precisa ter mais que 6 caracteres';
    }
    return null;
  }

  Future<void> submitForm() async {
    bool isValidated = formKey.currentState?.validate() ?? false;
    if (!isValidated) {
      return;
    }
    print('Vai tentar logar');
    try {
      print('Entrou! $email $passwordConfirm');

      await storeAuth.login(email, passwordConfirm);

      /* Navigator.push(
          context, MaterialPageRoute(builder: (context) => const MyHomePage())); */
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const MyHomePage()));
    } on AuthException catch (e) {
      var snackBar = SnackBar(
        content: Text(e.message),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print('Catch ${e.message}');
    }
    formKey.currentState?.save();

    // await auth();
    // Modular.to.navigate('${HomePage.id}/');
  }

  logar() async {
    try {
      print('Entrou!');
      print('$email $passwordConfirm');
      await storeAuth.login('teste@gmail.com', 'passwordConfirm');
    } on AuthException catch (e) {
      print('Catch ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    print(storeAuth.isAuthenticated);

    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          Color(0xFF0199A4),
          Color.fromRGBO(255, 188, 117, 0.9),
        ], begin: Alignment.topLeft, end: Alignment.bottomRight),
      ),
      padding: MediaQuery.of(context).viewInsets.copyWith(left: 32, right: 32),
      alignment: Alignment.center,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(children: [
                    /* SizedBox(
                      height: 100,
                      child: Image.asset('images/logo_clinica_2.jpg',
                          fit: BoxFit.fill),
                    ), */
                    const SizedBox(height: 16),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      onChanged: onChangeEmail,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          label: Text('Digite seu email')),
                      autovalidateMode: AutovalidateMode.disabled,
                      focusNode: emailFocus,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(senhaFocus);
                      },
                      validator: emailValidator,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      obscureText: obscureText,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.key),
                          label: const Text('Digite sua senha'),
                          suffixIcon: IconButton(
                              icon: Icon(passwordSufixIcon),
                              onPressed: changeObscureText)),
                      // autovalidateMode: AutovalidateMode.onUserInteraction,
                      focusNode: senhaFocus,
                      textInputAction: TextInputAction.done,
                      onChanged: onChangePassword,
                      onFieldSubmitted: (value) {
                        submitForm();
                      },
                      validator: passwordValidator,
                    ),
                  ]),
                  const SizedBox(height: 32),
                  ElevatedButton(
                      onPressed: submitForm, child: const Text('ENTRAR'))
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
