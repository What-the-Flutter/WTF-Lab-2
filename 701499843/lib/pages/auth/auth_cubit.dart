import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit()
      : super(
          AuthState(null),
        );

  Future<void> authorize() async {
    var userCredential = await FirebaseAuth.instance.signInAnonymously();
    print(userCredential.user);

    emit(
      state.copyWith(userCredential: userCredential),
    );
  }
}
