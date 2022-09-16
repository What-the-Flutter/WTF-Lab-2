import 'package:flutter/material.dart';

import '../../constants/constants.dart';

ThemeData get darkThemeData {
  return ThemeData.light().copyWith(
    backgroundColor: DarkColors.kBackgroundColor,
    appBarTheme: const AppBarTheme().copyWith(
      centerTitle: true,
      iconTheme: _darkIconThemeData,
      actionsIconTheme: _darkIconThemeData,
      shadowColor: Colors.transparent,
      titleTextStyle: _darkAppBarTextStyle,
      toolbarTextStyle: _darkAppBarTextStyle,
      backgroundColor: DarkColors.kBackgroundColor,
    ),
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
    floatingActionButtonTheme: const FloatingActionButtonThemeData().copyWith(
      backgroundColor: LightColors.kPrimaryColor,
      iconSize: 36,
      elevation: 0,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: DarkColors.kBackgroundColor,
      height: 65,
      indicatorColor: DarkColors.kSecondaryColor,
      labelTextStyle: MaterialStateProperty.all(
        const TextStyle(
          color: DarkColors.kBackgroundColor,
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
    color: DarkColors.kOnBackgroundColor,
    size: 36,
  );
}

TextStyle get _darkAppBarTextStyle {
  return const TextStyle().copyWith(
    color: LightColors.kOnBackgroundColor,
    fontSize: 26,
  );
}
