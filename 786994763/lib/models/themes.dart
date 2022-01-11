import 'package:flutter/material.dart';

enum ThemeKeys {
  light,
  dark,
}

class Themes {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: Colors.white,
    hoverColor: Colors.green,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: const Color(0xff7289da),
      background: const Color(0xffbed1dd),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 26,
        color: Colors.white,
      ),
      titleMedium: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Color(0xff2c2f33),
      ),
      bodySmall: TextStyle(
        fontSize: 18,
        color: Color(0xff2c2f33),
      ),
    ),
    primaryColorDark: const Color(0xff2c2f33),
    brightness: Brightness.light,
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: const Color(0xff2c2f33),
    hoverColor: Colors.green,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: const Color(0xff7289da),
      background: const Color(0xffbed1dd),
      brightness: Brightness.dark,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24,
        color: Colors.white,
      ),
      titleMedium: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24,
        color: Color(0xff2c2f33),
      ),
      bodyMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodySmall: TextStyle(
        fontSize: 18,
        color: Colors.white,
      ),
    ),
    primaryColorDark: Colors.white,
    brightness: Brightness.dark,
  );

  static ThemeData getThemeByKey(ThemeKeys key) {
    switch (key) {
      case ThemeKeys.dark:
        return Themes.darkTheme;
      case ThemeKeys.light:
        return Themes.lightTheme;
      default:
        return Themes.lightTheme;
    }
  }
}
