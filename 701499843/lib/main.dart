import 'package:flutter/material.dart';

import 'pages/home.dart';
import 'themes/inherited_theme.dart';

void main() {
  runApp(const ChatJournalApp());
}

class ChatJournalApp extends StatelessWidget {
  const ChatJournalApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AppThemeProvider(
      child: WithInheritedApp(),
    );
  }
}

class WithInheritedApp extends StatelessWidget {
  const WithInheritedApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WTF Project',
      theme: Inherited.of(context).themeData,
      home: const HomePage(title: 'Home'),
    );
  }
}
