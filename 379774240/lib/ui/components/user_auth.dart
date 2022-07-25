import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserAuthentication extends StatefulWidget {
  final Widget child;

  const UserAuthentication({
    super.key,
    required this.child,
  });

  @override
  State<UserAuthentication> createState() => _UserAuthenticationState();
}

class _UserAuthenticationState extends State<UserAuthentication> {
  @override
  void initState() {
    _anonimusAuth();
    super.initState();
  }

  void _anonimusAuth() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
