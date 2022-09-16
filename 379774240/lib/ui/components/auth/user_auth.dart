import 'package:flutter/material.dart';

import 'user_auth_cubit.dart';

class UserAuth extends StatefulWidget {
  final UserAuthCubit _cubit = UserAuthCubit();
  final Widget child;

  UserAuth({
    super.key,
    required this.child,
  });

  @override
  State<UserAuth> createState() => _UserAuthState();
}

class _UserAuthState extends State<UserAuth> {
  @override
  void initState() {
    widget._cubit.anonimusAuth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
