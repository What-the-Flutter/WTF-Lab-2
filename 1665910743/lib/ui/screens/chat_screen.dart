import 'package:flutter/material.dart';

import '../widgets/chat_screen_body.dart';
import '../widgets/home_widget.dart';

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
