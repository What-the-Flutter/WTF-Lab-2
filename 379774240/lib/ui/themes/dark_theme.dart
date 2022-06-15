import 'package:flutter/material.dart';

import '../constants/constants.dart';

ThemeData darkThemeData() {
  return ThemeData.light().copyWith(
    backgroundColor: DarkColors.kBackgroundColor,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      background: DarkColors.kBackgroundColor,
      surface: DarkColors.kSurfaceColor,
      primary: DarkColors.kPrimaryColor,
      secondary: DarkColors.kSecondaryColor,
      onBackground: DarkColors.kOnBackgroundColor,
      onSurface: DarkColors.kOnSurfaceColor,
      onPrimary: DarkColors.kOnPrimaryColor,
      onSecondary: DarkColors.kOnSecondaryColor,
      error: DarkColors.kErrorColor,
    ),
    appBarTheme: const AppBarTheme().copyWith(
      centerTitle: true,
      iconTheme: _darkIconThemeData,
      actionsIconTheme: _darkIconThemeData,
      shadowColor: Colors.transparent,
      titleTextStyle: _darkAppBarTextStyle,
      toolbarTextStyle: _darkAppBarTextStyle,
      backgroundColor: DarkColors.kPrimaryColor,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData().copyWith(
      backgroundColor: LightColors.kSecondaryColor,
      iconSize: 36,
      elevation: 0,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: DarkColors.kBackgroundColor,
      height: 65,
      indicatorColor: DarkColors.kSurfaceColor,
      labelTextStyle: MaterialStateProperty.all(
        const TextStyle(
          color: DarkColors.kOnBackgroundColor,
          fontSize: 12,
        ),
      ),
    ),
    primaryColor: DarkColors.kPrimaryColor,
    scaffoldBackgroundColor: DarkColors.kBackgroundColor,
    bottomAppBarColor: DarkColors.kSurfaceColor,
    errorColor: DarkColors.kErrorColor,
  );
}

IconThemeData get _darkIconThemeData {
  return const IconThemeData().copyWith(
    color: LightColors.kOnPrimaryColor,
    size: 30,
  );
}

TextStyle get _darkAppBarTextStyle {
  return const TextStyle().copyWith(
    color: LightColors.kOnPrimaryColor,
    fontSize: 22,
  );
}
