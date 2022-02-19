import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() => runApp(const ChatJournalApp());

class ChatJournalApp extends StatelessWidget {
  const ChatJournalApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat Journal',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromRGBO(231, 233, 238, 1),
      ),
      home: const HomePage(title: 'Home'),
    );
  }
}