import 'package:flutter/material.dart';

enum MyThemeKeys { light, dark }

class MyThemes {
  static final ThemeData lightTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 74, 138, 90),
    ),
    primaryColor: const Color.fromARGB(255, 74, 138, 90),
    primaryColorLight: const Color.fromARGB(255, 74, 138, 90),
    brightness: Brightness.light,
    bottomAppBarColor: const Color.fromARGB(255, 74, 138, 90),
  );

  static final ThemeData darkTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 65, 104, 75),
    ),
    primaryColor: const Color.fromARGB(255, 65, 104, 75),
    primaryColorLight: const Color.fromARGB(255, 65, 104, 75),
    brightness: Brightness.dark,
    bottomAppBarColor: const Color.fromARGB(255, 65, 104, 75),
  );
}
