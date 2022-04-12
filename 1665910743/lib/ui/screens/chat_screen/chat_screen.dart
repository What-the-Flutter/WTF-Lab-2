import 'package:flutter/material.dart';

import '../Chat_Screen/chat_screen_body.dart';
import '../home/home_widget.dart';

class ChatScreen extends StatelessWidget {
  final String categoryTitle;

  const ChatScreen({
    Key? key,
    required this.categoryTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          categoryTitle,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Home(),
            ),
          ),
        ),
      ),
      body: ChatScreenBody(
        categoryTitle: categoryTitle,
      ),
    );
  }
}
