import 'package:flutter/material.dart';

enum MyThemeKeys { light, dark }

class MyThemes {
  static final ThemeData lightTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 202, 142, 212),
    ),
    primaryColor: const Color.fromARGB(255, 202, 142, 212),
    primaryColorLight: const Color.fromARGB(255, 202, 142, 212),
    brightness: Brightness.light,
    bottomAppBarColor: const Color.fromARGB(255, 202, 142, 212),
  );

  static final ThemeData darkTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 118, 86, 124),
    ),
    primaryColor: const Color.fromARGB(255, 118, 86, 124),
    primaryColorLight: const Color.fromARGB(255, 118, 86, 124),
    brightness: Brightness.dark,
    bottomAppBarColor: const Color.fromARGB(255, 118, 86, 124),
  );

  static ThemeData getThemeFromKey(MyThemeKeys themeKey) {
    switch (themeKey) {
      case MyThemeKeys.light:
        return lightTheme;
      case MyThemeKeys.dark:
        return darkTheme;
      default:
        return lightTheme;
    }
  }
}
