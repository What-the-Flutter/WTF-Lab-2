import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'user_auth_state.dart';

class UserAuthCubit extends Cubit<UserAuthState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  UserAuthCubit() : super(const UserAuthState());

  void anonimusAuth() async {
    try {
      await _firebaseAuth.signInAnonymously();
    } catch (e) {
      print(e);
    }
  }
}
