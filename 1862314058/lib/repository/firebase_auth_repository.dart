import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthRepository {
  final FirebaseAuth _auth;

  FirebaseAuthRepository(this._auth);

  Stream<User?> get authStateChanged => _auth.authStateChanges();

  Future<bool> isAuth() async {
    return FirebaseAuth.instance.currentUser != null;
  }

  Future<User?> signInAnonymous() async {
    try {
      final result = await _auth.signInAnonymously();
      final user = result.user;
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  User? get currentUser => _auth.currentUser;
}
