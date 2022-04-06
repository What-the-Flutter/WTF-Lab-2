import 'package:firebase_auth/firebase_auth.dart';

class AuthState {
  final UserCredential? userCredential;
  AuthState(this.userCredential);

  AuthState copyWith({
    UserCredential? userCredential,
  }) {
    return AuthState(userCredential ?? this.userCredential);
  }
}
