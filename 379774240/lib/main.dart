import 'package:flutter/material.dart';

import 'inherited/app_state.dart';
import 'screens/home/home_screen.dart';
import 'themes.dart';

void main() {
  runApp(ChatJournal());
}

class ChatJournal extends StatelessWidget {
  final String appTitle = 'Chat Journal';

  @override
  Widget build(BuildContext context) {
    return StateWidget(
      child: MainApp(appTitle: appTitle),
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({
    Key? key,
    required this.appTitle,
  }) : super(key: key);

  final String appTitle;

  @override
  Widget build(BuildContext context) {
    final isLightTheme = StateInheritedWidget.of(context).state.isLightTheme;

    return MaterialApp(
      title: appTitle,
      debugShowCheckedModeBanner: false,
      theme: isLightTheme ? lightThemeData(context) : darkThemeData(context),
      home: HomeScreen(),
    );
  }
}
