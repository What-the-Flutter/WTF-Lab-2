class AuthState {
  final bool isAuth;

  AuthState({
    required this.isAuth,
  });

  AuthState copyWith({
    bool? isAuth,
  }) {
    return AuthState(
      isAuth: isAuth ?? this.isAuth,
    );
  }
}
