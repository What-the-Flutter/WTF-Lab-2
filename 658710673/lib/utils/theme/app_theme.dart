import 'package:flutter/material.dart';

import '../constants.dart';

enum ThemeKeys { light, dark }

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Constants.lSecondaryColor,
    colorScheme: const ColorScheme.light(
      primary: Constants.lPrimaryColor,
      secondary: Constants.lSecondaryColor,
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Constants.lPrimaryColor,
      foregroundColor: Constants.lIconColor,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Constants.lPrimaryColor,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Constants.lPrimaryColor,
      unselectedItemColor: Constants.lIconColor,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Constants.dSecondaryColor,
    colorScheme: const ColorScheme.dark(
      primary: Constants.dPrimaryColor,
      secondary: Constants.dSecondaryColor,
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Constants.dPrimaryColor,
      foregroundColor: Constants.dIconColor,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Constants.dPrimaryColor,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Constants.dPrimaryColor,
      unselectedItemColor: Constants.dIconColor,
    ),
  );
}