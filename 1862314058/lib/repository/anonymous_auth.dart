import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Future<User?> signInAnonymous() async {
    try {
      final result = await _firebaseAuth.signInAnonymously();
      final user = result.user;
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
