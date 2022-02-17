import 'package:flutter/material.dart';

class MessagesScreen extends StatelessWidget {
  final String title;

  const MessagesScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
    );
  }
}
