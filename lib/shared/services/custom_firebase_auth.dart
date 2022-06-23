import 'package:firebase_auth/firebase_auth.dart';

class AuthException implements Exception {
  String message;

  AuthException(this.message);
}

class CustomFirebaseAuth {
  final _auth = FirebaseAuth.instance;

  CustomFirebaseAuth() {
    // printTken();
  }
  printTken() async {
    print('TOKEN');
    if (_auth.currentUser != null) {
      // print(await _auth.currentUser!.getIdTokenResult());
      print(await _auth.currentUser!.getIdToken());
      print(_auth.currentUser!.uid);
      // print(await _auth.currentUser!.);
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      /* print(await result.user!.getIdToken());
      print(await result.user!.getIdTokenResult(true)
        ..token); */
      if (result.user == null) {
        throw AuthException('Ocorreu um erro, tente novamente.');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw AuthException('Não há um usuário cadastrado com este email!');
      } else if (e.code == 'wrong-password') {
        throw AuthException('Senha incorreta!');
      } else if (e.code == 'user-disabled') {
        throw AuthException('O usuário foi desetivado!');
      } else if (e.code == 'invalid-email') {
        throw AuthException('Email inválido!');
      }
    }
  }

  Future<void> register(String email, String password) async {
    try {
      // _auth.
      // print('Tentou criar conta com $email e $password');
      final result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      // print('Tem um user ');
      if (result.user == null) {
        throw AuthException('Ocorreu um erro, tente novamente.');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw AuthException('Já há um usuário cadastrado com este email!');
      } else if (e.code == 'invalid-email') {
        throw AuthException('Email inválido!');
      } else if (e.code == 'operation-not-allowed') {
        throw AuthException('Operação não permitida!');
      } else if (e.code == 'weak-password') {
        throw AuthException('A senha é muito fraca!');
      } else {
        throw AuthException('Ocorreu um erro, tente novamente.');
      }
    }
  }

  Future<void> recoverPassword(String email) async {
    // print(await _auth.curentuser!.getIdTokenResult(true)..token);
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        throw AuthException('Email inválido!');
      } else if (e.code == 'user-not-found') {
        throw AuthException('Não há um usuário cadastrado com este email');
      } else {
        throw AuthException('Ocorreu um erro, tente novamente.');
      }
    }
  }

  Future<void> logout() async {
    // print(await _auth.curentuser!.getIdTokenResult(true)..token);
    await _auth.signOut();
  }

  bool get isAuthenticated {
    if (_auth.currentUser?.email == null) {
      return false;
    }
    return true;
  }

  Future<void> reloadUser() async {
    if (_auth.currentUser == null) return;
    await _auth.currentUser!.reload();
  }

  Future<void> sendVerificationEmail() async {
    try {
      // print('Este é o email ${_auth.currentUser!.email}');
      await _auth.currentUser!.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      print('O ERRO ${e.message}');
      if (e.code == 'too-many-requests') {
        throw AuthException(
            'Você tentou muitas vezes, verifique seu email e a caixa de spam.');
      }
      // print('DEU RUIM ${e.code}');

      throw AuthException('Ocorreu um erro, tente novamente!');
    }
  }

  bool get wasEmailVerified {
    return _auth.currentUser?.emailVerified ?? false;
  }

  String get userEmail {
    return _auth.currentUser!.email!;
  }
}
