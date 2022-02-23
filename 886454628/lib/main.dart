import 'package:flutter/material.dart';

import 'screen.dart';
import 'themes.dart';

void main() {
  runApp(
    CustomTheme(
      themeData: MyThemes.lightTheme,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Journal',
      theme: InheritedCustomTheme.of(context).themeData,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
