import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'themes/inherited_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AppThemeProvider(
      child: MyMaterialApp(),
    );
  }
}

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WTF Project',
      theme: Inherited.of(context).themeData,
      home: const MyHomePage(title: 'Home'),
    );
  }
}
