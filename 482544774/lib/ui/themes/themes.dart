import 'package:flutter/material.dart';

CustomTheme currrentTheme = CustomTheme();

// ignore: prefer_mixin
class CustomTheme with ChangeNotifier {
  static bool _isDarkTheme = false;
  ThemeMode get currentTheme => _isDarkTheme ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: Colors.indigo,
      accentColor: Colors.amber[300],
      cardColor: Colors.amber[300],
      brightness: Brightness.light,

      primaryTextTheme: const TextTheme(
        bodyText1: TextStyle(color: Colors.black, fontSize: 16),
      ),

      iconTheme: const IconThemeData(color: Colors.white),
      accentIconTheme: const IconThemeData(color: Colors.black),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: Colors.indigo[300],
      accentColor: Colors.amber[300],
      cardColor: Colors.indigo[300],
      brightness: Brightness.dark,

      primaryTextTheme: const TextTheme(
        bodyText1: TextStyle(color: Colors.white, fontSize: 16.0),
      ),

      iconTheme: const IconThemeData(color: Colors.black),
      primaryIconTheme: const IconThemeData(color: Colors.white),
      accentIconTheme: const IconThemeData(color: Colors.indigo),
    );
  }
}
