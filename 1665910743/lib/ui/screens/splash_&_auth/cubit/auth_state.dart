part of 'auth_cubit.dart';

// _SupportState _supportState = _SupportState.unknown;
//   bool? _canCheckBiometrics;
//   List<BiometricType>? _availableBiometrics;
//   String _authorized = 'Not Authorized';
//   bool _isAuthenticating = false;

enum SupportState {
  unknown,
  supported,
  unsupported,
}

class AuthState {
  final bool? canCheckBiometrics;
  final List<BiometricType>? availableBiometrics;
  final bool isAuthenticating;
  final String authorized;
  final SupportState supportState;

  AuthState({
    this.canCheckBiometrics,
    this.availableBiometrics,
    this.isAuthenticating = false,
    this.authorized = 'Not Authorized',
    this.supportState = SupportState.unknown,
  });

  AuthState copyWith({
    bool? canCheckBiometrics,
    List<BiometricType>? availableBiometrics,
    bool? isAuthenticating,
    String? authorized,
    SupportState? supportState,
  }) {
    return AuthState(
      canCheckBiometrics: canCheckBiometrics ?? this.canCheckBiometrics,
      availableBiometrics: availableBiometrics ?? this.availableBiometrics,
      isAuthenticating: isAuthenticating ?? this.isAuthenticating,
      authorized: authorized ?? this.authorized,
      supportState: supportState ?? this.supportState,
    );
  }
}
