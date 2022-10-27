import 'package:flutter/material.dart';

import 'pages/main_page.dart';
import 'themes/theme_changer.dart';

void main() {
  runApp(StateChanger(
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeChanger.of(context).theme,
      //themeMode: ThemeChanger.of(context).changeTheme(MediaQuery.of(context).platformBrightness),
      home: const MainPage(),
      //home: const ChatPage(chatTitle: 'Travel'),
    );
  }
}
