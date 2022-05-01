import 'package:flutter/material.dart';

class AppBarButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback buttonHandler;

  AppBarButton(this.icon, this.buttonHandler, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: buttonHandler,
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }
}
