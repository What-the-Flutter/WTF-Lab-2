import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: Colors.teal,
    hintColor: Colors.black,
    scaffoldBackgroundColor: Colors.white,
    shadowColor: Colors.grey[200],
    backgroundColor: Colors.black,
    highlightColor: Colors.white,
    colorScheme:
        ColorScheme.light(secondary: Colors.teal, primary: Colors.green[100]!),
  );

  static ThemeData darkTheme = ThemeData(
      primaryColor: Colors.black,
      highlightColor: Colors.white,
      hintColor: Colors.white,
      backgroundColor: Colors.white,
      scaffoldBackgroundColor: Colors.black,
      colorScheme: ColorScheme.dark(
          secondary: Colors.yellow, primary: Colors.yellow[100]!),
      bottomAppBarColor: Colors.black87,
      shadowColor: Colors.black87);
}
