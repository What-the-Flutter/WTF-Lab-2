import 'package:flutter/material.dart';

class AppBarButton extends StatelessWidget {
  AppBarButton(this.icon, this.buttonHandler, {Key? key}) : super(key: key);

  final IconData icon;
  final VoidCallback buttonHandler;

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
