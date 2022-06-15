import 'package:flutter/material.dart';

import 'UI/screens/home/home_screen.dart';
import 'UI/themes/dark_theme.dart';
import 'UI/themes/light_theme.dart';
import 'inherited/app_theme.dart';

class ChatJournal extends StatelessWidget {
  final String _appTitle = 'Chat Journal';

  ChatJournal({super.key});

  @override
  Widget build(BuildContext context) {
    return AppThemeState(
      child: Builder(
        builder: (context) {
          final isLightTheme = AppThemeInheritedWidget.of(context).isLightTheme;

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: _appTitle,
            theme: isLightTheme ? lightThemeData() : darkThemeData(),
            home: HomeScreen(),
          );
        },
      ),
    );
  }
}
