import 'package:flutter/material.dart';

import '../constants.dart';

enum ThemeKeys { light, dark }
enum FontSizeKeys { small, medium, large }

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: MColors.lSecondaryColor,
    colorScheme: const ColorScheme.light(
      primary: MColors.lPrimaryColor,
      secondary: MColors.lSecondaryColor,
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: MColors.lPrimaryColor,
      foregroundColor: MColors.lIconColor,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: MColors.lPrimaryColor,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: MColors.lPrimaryColor,
      unselectedItemColor: MColors.lIconColor,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: MColors.dSecondaryColor,
    colorScheme: const ColorScheme.dark(
      primary: MColors.dPrimaryColor,
      secondary: MColors.dSecondaryColor,
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: MColors.dPrimaryColor,
      foregroundColor: MColors.dIconColor,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: MColors.dPrimaryColor,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: MColors.dPrimaryColor,
      unselectedItemColor: MColors.dIconColor,
    ),
  );
}
