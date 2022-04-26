import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> authorize() async {
    try {
      final result = await _auth.signInAnonymously();
      final user = result.user;
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
