import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/firebase_auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuthRepository firebaseAuthRepository;
  late StreamSubscription<User>? _authUserSubscription;

  AuthCubit(this.firebaseAuthRepository)
      : super(AuthState(authStatus: AuthStatus.unauth)) {
    ///_authUserSubscription = firebaseAuthRepository.authStateChanged.listen(user) as StreamSubscription<User>?;
    firebaseAuthRepository.authStateChanged.listen((user) {
      print(user);
    });
  }

  void checkAuth() async {
    if (firebaseAuthRepository.currentUser != null) {
      emit(
        state.copyWith(authStatus: AuthStatus.auth),
      );
    } else {
      await firebaseAuthRepository.signInAnonymous();
      emit(
        state.copyWith(authStatus: AuthStatus.auth),
      );
    }
  }

  void signAnon() async {
    await firebaseAuthRepository.signInAnonymous();
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
