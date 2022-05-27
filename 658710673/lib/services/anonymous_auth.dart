import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> authorize() async {
    final user = _auth.currentUser;
    if(user != null){
      return user;
    } else {
      try {
        final result = await _auth.signInAnonymously();
        return result.user;
      } catch (e) {
        print(e);
        return null;
      }
    }
  }
}
