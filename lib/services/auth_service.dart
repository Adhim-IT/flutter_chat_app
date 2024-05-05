import 'package:firebase_auth/firebase_auth.dart';

class AuthServcie {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? _user;

  User? get user {
    return _user;
  }

  AuthServcie() {
    _firebaseAuth.authStateChanges().listen(authStateChangesStreamistener);
  }

  Future<bool> login(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if (credential.user != null) {
        _user = credential.user;
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool>logout() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  void authStateChangesStreamistener(User? user) {
    if (user != null) {
      _user = user;
    } else {
      _user = null;
    }
  }
}
