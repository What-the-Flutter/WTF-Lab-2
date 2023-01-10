import 'package:flutter/material.dart';

const _primaryColorLight = Color(0xfffde0d3);
const _primaryColorDarkLight = Color(0xff424242);
const _primaryColorDarkDark = Color(0xff2a2a2a);
const _primaryColorDark = Color(0xfff88766);

enum TextSizeKeys {
  small,
  medium,
  large,
}

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
  navigationBarTheme: const NavigationBarThemeData(
    backgroundColor: _primaryColorLight,
    indicatorColor: _primaryColorDark,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: _primaryColorLight,
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
  indicatorColor: Colors.teal,
  navigationBarTheme: const NavigationBarThemeData(
    backgroundColor: _primaryColorDarkDark,
    indicatorColor: Colors.teal,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: _primaryColorDarkDark,
  ),
);

TextStyle getBodyText(TextSizeKeys textSize, BuildContext context) {
  switch (textSize) {
    case TextSizeKeys.small: return Theme.of(context).textTheme.bodySmall!;
    case TextSizeKeys.medium: return Theme.of(context).textTheme.bodyMedium!;
    case TextSizeKeys.large: return Theme.of(context).textTheme.bodyLarge!;
  }
}

TextStyle getTitleText(TextSizeKeys textSize, BuildContext context) {
  switch (textSize) {
    case TextSizeKeys.small: return Theme.of(context).textTheme.titleSmall!;
    case TextSizeKeys.medium: return Theme.of(context).textTheme.titleMedium!;
    case TextSizeKeys.large: return Theme.of(context).textTheme.titleLarge!;
  }
}

TextStyle getHeadLineText(TextSizeKeys textSize, BuildContext context) {
  switch (textSize) {
    case TextSizeKeys.small: return Theme.of(context).textTheme.headlineSmall!;
    case TextSizeKeys.medium: return Theme.of(context).textTheme.headlineMedium!;
    case TextSizeKeys.large: return Theme.of(context).textTheme.headlineLarge!;
  }
}