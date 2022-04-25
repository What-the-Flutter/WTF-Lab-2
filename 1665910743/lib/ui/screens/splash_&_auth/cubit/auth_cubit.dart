import 'package:bloc/bloc.dart';
import 'package:local_auth/local_auth.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState());

  void canCheckBiometrics(bool value) {
    emit(state.copyWith(canCheckBiometrics: value));
  }

  void availableBiometrics(List<BiometricType>? list) {
    emit(state.copyWith(availableBiometrics: list));
  }

  void isAuthenticating(bool value) {
    emit(state.copyWith(isAuthenticating: value));
  }

  void authorized(String value) {
    emit(state.copyWith(authorized: value));
  }

  void supportState(SupportState value) {
    emit(state.copyWith(supportState: value));
  }
}
