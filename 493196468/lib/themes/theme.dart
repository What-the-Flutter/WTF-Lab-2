import 'package:flutter/material.dart';

const _primaryColorLight = Color(0xfffde0d3);
const _primaryColorDark = Color(0xfff88766);

final lightTheme = ThemeData(
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
  primaryColorLight: _primaryColorLight,
  primaryColorDark: _primaryColorDark,
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
  listTileTheme: const ListTileThemeData(

  ),
);