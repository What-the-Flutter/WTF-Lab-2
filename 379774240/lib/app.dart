import 'package:flutter/material.dart';

import 'inherited/app_theme.dart';
import 'ui/screens/home/home_screen.dart';
import 'ui/themes/dark_theme.dart';
import 'ui/themes/light_theme.dart';

class ChatJournalApp extends StatelessWidget {
  final String _appTitle = 'Chat Journal';
  const ChatJournalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppThemeState(
      child: Builder(
        builder: (context) {
          final isLightTheme = AppThemeInheritedWidget.of(context).isLightTheme;

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: _appTitle,
            theme: isLightTheme ? lightThemeData : darkThemeData,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
