import 'package:flutter/material.dart';

enum MyThemeKeys { light, dark }
enum MyFontSize { small, medium, large }

class FontSize {
  static final TextTheme small = const TextTheme(
    bodyText1: TextStyle(fontSize: 15.0, color: Colors.black87),
    bodyText2: TextStyle(fontSize: 10.0, color: Colors.black87),
  );
  static final TextTheme medium = const TextTheme(
    bodyText1: TextStyle(fontSize: 20.0, color: Colors.black87),
    bodyText2: TextStyle(fontSize: 15.0, color: Colors.black87),
  );
  static final TextTheme large = const TextTheme(
    bodyText1: TextStyle(fontSize: 25.0, color: Colors.black87),
    bodyText2: TextStyle(fontSize: 20.0, color: Colors.black87),
  );
}

class MyThemes {
  static const lightColor = Color.fromARGB(255, 74, 138, 90);
  static const darkColor = Color.fromARGB(255, 65, 104, 75);
  static const selectedColor = Color.fromARGB(255, 49, 87, 58);

  static final ThemeData lightTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: lightColor,
    ),
    primaryColor: lightColor,
    primaryColorLight: lightColor,
    brightness: Brightness.light,
    bottomAppBarColor: lightColor,
  );

  static final ThemeData darkTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: darkColor,
    ),
    primaryColor: darkColor,
    primaryColorLight: darkColor,
    brightness: Brightness.dark,
    bottomAppBarColor: darkColor,
  );
}
