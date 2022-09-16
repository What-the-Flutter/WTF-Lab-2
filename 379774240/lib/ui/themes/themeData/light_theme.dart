import 'package:flutter/material.dart';

import '../../constants/constants.dart';

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
      backgroundColor: LightColors.kBackgroundColor,
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
      backgroundColor: LightColors.kPrimaryColor,
      iconSize: 36,
      elevation: 0,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: LightColors.kBackgroundColor,
      height: 65,
      indicatorColor: LightColors.kSecondaryColor,
      labelTextStyle: MaterialStateProperty.all(
        const TextStyle(
          color: LightColors.kBackgroundColor,
          fontSize: 12,
        ),
      ),
    ),
    primaryColor: LightColors.kPrimaryColor,
    scaffoldBackgroundColor: LightColors.kBackgroundColor,
    bottomAppBarColor: LightColors.kSurfaceColor,
    errorColor: LightColors.kErrorColor,
  );
}

IconThemeData get _lightIconThemeData {
  return const IconThemeData().copyWith(
    color: LightColors.kOnBackgroundColor,
    size: 36,
  );
}

TextStyle get _lightAppBarTextStyle {
  return const TextStyle().copyWith(
    color: LightColors.kOnBackgroundColor,
    fontSize: 26,
  );
}
