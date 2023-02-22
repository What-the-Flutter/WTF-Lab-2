enum AuthStatus {
  auth,
  unauth,
}

class AuthState {
  final AuthStatus authStatus;

  AuthState({
    required this.authStatus,
  });

  AuthState copyWith({
    AuthStatus? authStatus,
  }) {
    return AuthState(
      authStatus: authStatus ?? this.authStatus,
    );
  }
}
