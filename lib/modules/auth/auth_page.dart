import 'package:email_validator/email_validator.dart';
import 'package:exemplo_firebase/modules/login/login_page.dart';
import 'package:flutter/material.dart';

import '../../shared/services/custom_firebase_auth.dart';
import '../verify_email/verify_email_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  CustomFirebaseAuth storeAuth = CustomFirebaseAuth();

  final formKey = GlobalKey<FormState>();
  bool obscureText = true;
  String password = '';
  String passwordConfirm = '';
  String email = '';

  final emailFocus = FocusNode();
  final senhaFocus = FocusNode();
  final passwordConfirmFocus = FocusNode();

  IconData get passwordSufixIcon {
    return obscureText ? Icons.visibility : Icons.visibility_off;
  }

  void changeObscureText() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  void onChangeEmail(String value) => email = value;

  void onChangePassword(String value) => password = value;

  void onChangePasswordConfirm(String value) => passwordConfirm = value;

  String? emailValidator(String? email) {
    if (email == null || email.trim().isEmpty) {
      return 'Por favor, preencha o email!';
    } else if (!EmailValidator.validate(email)) {
      return 'Não é um email válido!';
    }
    return null;
  }

  String? passwordValidator(String? pass) {
    if (password.length < 6) {
      return 'A senha precisa ter mais que 6 caracteres.';
    } else if (password != passwordConfirm) {
      return 'As senhas não conferem!';
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

      await storeAuth.register(email, password);

      if (!mounted) return;
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const VerifyEmailPage()));
    } on AuthException catch (e) {
      var snackBar = SnackBar(
        width: 344,
        behavior: SnackBarBehavior.floating,
        elevation: 1,
        content: Text(e.message),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // print('Catch ${e.message}');
    }
    formKey.currentState?.save();
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
          prefixIcon: Icon(Icons.person), label: Text('Digite seu email')),
      autovalidateMode: AutovalidateMode.disabled,
      focusNode: emailFocus,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(senhaFocus);
      },
      validator: emailValidator,
    );
  }

  Widget _passwordTextInput(String label,
      {FocusNode? focusNode,
      void Function(String)? onChanged,
      TextInputAction? textInputAction,
      void Function(String)? onFieldSubmitted}) {
    return TextFormField(
      obscureText: obscureText,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.key),
          label: Text(label),
          suffixIcon: IconButton(
              icon: Icon(passwordSufixIcon), onPressed: changeObscureText)),
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      focusNode: focusNode,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      validator: passwordValidator,
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
    return Scaffold(
        appBar: AppBar(title: const Text('Registre-se')),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xFF0199A4),
              Color.fromRGBO(255, 188, 117, 0.9),
            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          ),
          // padding: MediaQuery.of(context).viewInsets.copyWith(left: 32, right: 32),
          padding:
              const EdgeInsets.only(left: 32, right: 32, top: 8, bottom: 8),
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
                        const SizedBox(height: 15),
                        const Text(
                            '* Certifique-se de utilizar o mesmo email cadastrado no sistema local.',
                            // textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w400)),
                        const SizedBox(height: 32),
                        _emailTextInput(),
                        const SizedBox(height: 16),
                        _passwordTextInput('Digite sua senha',
                            focusNode: senhaFocus,
                            onChanged: onChangePassword,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(passwordConfirmFocus);
                        }),
                        const SizedBox(height: 16),
                        _passwordTextInput('Confirme sua senha',
                            focusNode: passwordConfirmFocus,
                            onChanged: onChangePasswordConfirm,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) async {
                          await submitForm();
                        }),
                      ]),
                      const SizedBox(height: 32),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(40),
                              primary:
                                  const Color.fromRGBO(255, 188, 117, 0.9)),
                          onPressed: () async {
                            await submitForm();
                          },
                          child: const Text('REGISTRAR-SE')),
                      _customDividerOr(),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()));
                        },
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(40)),
                        label: const Text('VOLTAR'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
