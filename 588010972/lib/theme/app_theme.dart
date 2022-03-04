import 'package:flutter/material.dart';

enum ThemeName { light, dark }

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: Colors.teal,
    backgroundColor: Colors.white,
    textTheme: const TextTheme(
      subtitle1: TextStyle(
        color: Colors.black,
      ),
      subtitle2: TextStyle(
        color: Colors.grey,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.lightBlue,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          Colors.tealAccent,
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
    ),
    brightness: Brightness.light,
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: Colors.grey,
    backgroundColor: Colors.black38,
    brightness: Brightness.dark,
    textTheme: const TextTheme(
      subtitle1: TextStyle(
        color: Colors.white,
      ),
      subtitle2: TextStyle(
        color: Colors.white60,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.amber,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          Colors.amber,
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
    ),
  );

  static ThemeData changeTheme(ThemeName themeName) {
    switch (themeName) {
      case ThemeName.light:
        return lightTheme;
      case ThemeName.dark:
        return darkTheme;
      default:
        return lightTheme;
    }
  }
}
