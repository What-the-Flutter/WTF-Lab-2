import 'package:flutter/material.dart';

const _primaryColorLight = Color(0xfffde0d3);
const _primaryColorDarkLight = Color(0xff424242);
const _primaryColorDarkDark = Color(0xff2a2a2a);
const _primaryColorDark = Color(0xfff88766);

final lightTheme = ThemeData(
  backgroundColor: _primaryColorLight,
  primaryColor: Colors.white,
  primaryColorLight: _primaryColorLight,
  primaryColorDark: _primaryColorDark,
  appBarTheme: const AppBarTheme(
    color: _primaryColorLight,
    titleTextStyle: TextStyle(
      color: _primaryColorDark,
      fontSize: 20,
    )
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: _primaryColorDark,
    unselectedItemColor: _primaryColorLight,
  ),

  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    foregroundColor: _primaryColorDark,
    backgroundColor: _primaryColorLight,
    splashColor: _primaryColorDark,
  ),
  cardTheme: CardTheme(
    shape: RoundedRectangleBorder(
      side: const BorderSide(color: _primaryColorLight, width: 2),
      borderRadius: BorderRadius.circular(5),
    ),
  ),
  iconTheme: const IconThemeData(
    color: _primaryColorDark,
  ),
);

final darkTheme = ThemeData(
  primaryColorDark: _primaryColorDarkDark,
  primaryColorLight: _primaryColorDarkLight,
  primaryColor: Colors.grey,
  brightness: Brightness.dark,
  appBarTheme: const AppBarTheme(
      color: _primaryColorDarkDark,
      titleTextStyle: TextStyle(
        fontSize: 20,
      )
  ),
);