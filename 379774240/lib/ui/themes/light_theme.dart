import 'package:flutter/material.dart';

import '../constants/constants.dart';

ThemeData get lightThemeData {
  return ThemeData.light().copyWith(
    backgroundColor: LightColors.kBackgroundColor,
    appBarTheme: const AppBarTheme().copyWith(
      centerTitle: true,
      iconTheme: _lightIconThemeData,
      actionsIconTheme: _lightIconThemeData,
      shadowColor: Colors.transparent,
      titleTextStyle: _lightAppBarTextStyle,
      toolbarTextStyle: _lightAppBarTextStyle,
      backgroundColor: LightColors.kPrimaryColor,
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      background: LightColors.kBackgroundColor,
      surface: LightColors.kSurfaceColor,
      primary: LightColors.kPrimaryColor,
      secondary: LightColors.kSecondaryColor,
      onBackground: LightColors.kOnBackgroundColor,
      onSurface: LightColors.kOnSurfaceColor,
      onPrimary: LightColors.kOnPrimaryColor,
      onSecondary: LightColors.kOnSecondaryColor,
      error: LightColors.kErrorColor,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData().copyWith(
      backgroundColor: LightColors.kSecondaryColor,
      iconSize: 36,
      elevation: 0,
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: LightColors.kSurfaceColor,
      height: 65,
      indicatorColor: LightColors.kBackgroundColor,
    ),
    primaryColor: LightColors.kPrimaryColor,
    scaffoldBackgroundColor: LightColors.kBackgroundColor,
    bottomAppBarColor: LightColors.kSurfaceColor,
    errorColor: LightColors.kErrorColor,
  );
}

IconThemeData get _lightIconThemeData {
  return const IconThemeData().copyWith(
    color: LightColors.kOnPrimaryColor,
    size: 30,
  );
}

TextStyle get _lightAppBarTextStyle {
  return const TextStyle().copyWith(
    color: LightColors.kOnPrimaryColor,
    fontSize: 22,
    fontFamily: 'Quicksand',
    fontWeight: FontWeight.w500,
  );
}
