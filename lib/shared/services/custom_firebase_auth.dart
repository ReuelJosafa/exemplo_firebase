import 'package:firebase_auth/firebase_auth.dart';

class AuthException implements Exception {
  String message;

  AuthException(this.message);
}

class CustomFirebaseAuth {
  final _auth = FirebaseAuth.instance;

  CustomFirebaseAuth() {
    printTken();
  }
  printTken() async {
    print('TOKEN');
    if (_auth.currentUser != null) {
      // print(await _auth.currentUser!.getIdTokenResult());
      print(await _auth.currentUser!.getIdToken());
      print(await _auth.currentUser!.uid);
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
      }
    }
  }

  Future<void> register(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (result.user == null) {
        throw AuthException('Ocorreu um erro, tente novamente.');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw AuthException('Não há um usuário cadastrado com este email!');
      } else if (e.code == 'wrong-password') {
        throw AuthException('Senha incorreta!');
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
}
