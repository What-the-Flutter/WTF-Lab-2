import 'package:flutter/material.dart';


import '../../theme/theme_constant.dart';
import '../../theme/theme_handler.dart';
import 'app_page.dart';

ThemeHandler _themeHandler = ThemeHandler();

class ChatJournal extends StatelessWidget {
  const ChatJournal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeHandler.themeMode,
      home: const AppPage(title: 'Home'),
    );
  }
}
