import 'package:flutter/material.dart';

import 'constants.dart';

ThemeData lightThemeData(BuildContext context) {
  return ThemeData.light().copyWith(
    backgroundColor: LightColors.kBackgroundColor,
    appBarTheme: const AppBarTheme().copyWith(
      centerTitle: true,
      iconTheme: lightIconThemeData(context),
      actionsIconTheme: lightIconThemeData(context),
      shadowColor: Colors.transparent,
      titleTextStyle: lightAppBarTextStyle(context),
      toolbarTextStyle: lightAppBarTextStyle(context),
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

IconThemeData lightIconThemeData(BuildContext context) {
  return const IconThemeData().copyWith(
    color: LightColors.kOnPrimaryColor,
    size: 30,
  );
}

TextStyle lightAppBarTextStyle(BuildContext context) {
  return const TextStyle().copyWith(
    color: LightColors.kOnPrimaryColor,
    fontSize: 22,
  );
}

ThemeData darkThemeData(BuildContext context) {
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
      iconTheme: darkIconThemeData(context),
      actionsIconTheme: darkIconThemeData(context),
      shadowColor: Colors.transparent,
      titleTextStyle: darkAppBarTextStyle(context),
      toolbarTextStyle: darkAppBarTextStyle(context),
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
          const TextStyle(color: DarkColors.kOnBackgroundColor, fontSize: 12)),
    ),
    primaryColor: DarkColors.kPrimaryColor,
    scaffoldBackgroundColor: DarkColors.kBackgroundColor,
    bottomAppBarColor: DarkColors.kSurfaceColor,
    errorColor: DarkColors.kErrorColor,
  );
}

IconThemeData darkIconThemeData(BuildContext context) {
  return const IconThemeData().copyWith(
    color: LightColors.kOnPrimaryColor,
    size: 30,
  );
}

TextStyle darkAppBarTextStyle(BuildContext context) {
  return const TextStyle().copyWith(
    color: LightColors.kOnPrimaryColor,
    fontSize: 22,
  );
}
