import 'package:email_validator/email_validator.dart';
import 'package:exemplo_firebase/modules/auth/auth_page.dart';
import 'package:flutter/material.dart';

import '../../shared/services/custom_firebase_auth.dart';
import '../forgot_password/forgot_password_page.dart';
import '../verify_email/verify_email_page.dart';

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
  String password = '';
  String email = '';
  // String? error;

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

  void onChangePassword(String value) => password = value;

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
    // print('Vai tentar logar');
    try {
      // print('Entrou! $email $password');

      await storeAuth.login(email, password);

      /* Navigator.push(
          context, MaterialPageRoute(builder: (context) => const MyHomePage())); */
      if (!mounted) return;
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const VerifyEmailPage()));
    } on AuthException catch (e) {
      /* setState(() {
        error = e.message;
      }); */
      var snackBar = SnackBar(
        width: 344,
        behavior: SnackBarBehavior.floating,
        // margin: const EdgeInsets.all(8),
        elevation: 1,
        content: Text(e.message),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    formKey.currentState?.save();

    // await auth();
    // Modular.to.navigate('${HomePage.id}/');
  }

  final Widget _logoImage = SizedBox(
    height: 100,
    child: Image.asset('images/logo_clinica_2.jpg', fit: BoxFit.fill),
  );

  Widget _emailTextInput() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onChanged: onChangeEmail,
      decoration: const InputDecoration(
          prefixIcon: Icon(Icons.email), label: Text('Digite seu email')),
      autovalidateMode: AutovalidateMode.disabled,
      focusNode: emailFocus,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(senhaFocus);
      },
      validator: emailValidator,
    );
  }

  Widget _passwordTextInput() {
    return TextFormField(
      obscureText: obscureText,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.key),
          label: const Text('Digite sua senha'),
          suffixIcon: IconButton(
              icon: Icon(passwordSufixIcon), onPressed: changeObscureText)),
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      focusNode: senhaFocus,
      textInputAction: TextInputAction.done,
      onChanged: onChangePassword,
      onFieldSubmitted: (_) async {
        await submitForm();
      },
      validator: passwordValidator,
    );
  }

  Widget _forgotPasswordButton() {
    return Align(
      heightFactor: 1.0,
      alignment: Alignment.bottomRight,
      child: TextButton(
          child: const Text('Esqueceu a senha?'),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ForgotPasswordPage()));
          }),
    );
  }

  Widget _customDividerOr() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(children: const [
        Expanded(child: Divider(thickness: 2)),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 8), child: Text('ou')),
        Expanded(child: Divider(thickness: 2)),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    // print(storeAuth.isAuthenticated);

    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          Color(0xFF0199A4),
          Color.fromRGBO(255, 188, 117, 0.9),
        ], begin: Alignment.topLeft, end: Alignment.bottomRight),
      ),
      padding: const EdgeInsets.only(left: 32, right: 32, top: 32, bottom: 8),
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
                    _logoImage,
                    const SizedBox(height: 32),
                    _emailTextInput(),
                    const SizedBox(height: 16),
                    _passwordTextInput(),
                  ]),
                  _forgotPasswordButton(),

                  const SizedBox(height: 16),
                  // const SizedBox(height: 150),
                  /* if (error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ), */
                  ElevatedButton(
                    onPressed: submitForm,
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(40)),
                    child: const Text('ENTRAR'),
                  ),
                  _customDividerOr(),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(40),
                          primary: const Color.fromRGBO(255, 188, 117, 0.9)),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AuthPage()));
                      },
                      child: const Text('REGISTRAR-SE')),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
