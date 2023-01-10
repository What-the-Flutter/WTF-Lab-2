import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit()
      : super(
          AuthState(
            isAuth: false,
          ),
        );

  bool isUserAuth() {
    return state.isAuth;
  }

  // Future<void> signInAnonymous() async {
  //   var isAuth = false;
  //   try {
  //     final userCredential = await FirebaseAuth.instance.signInAnonymously();
  //     if (userCredential != null) {
  //       isAuth = true;
  //     }
  //     emit(
  //       state.copyWith(
  //         isAuth: isAuth,
  //       ),
  //     );
  //   } catch (e) {
  //     print('Firebase error');
  //   }
  // }
}
