import 'package:flutter/material.dart';

import 'constants.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
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

  static ThemeData darkTheme = ThemeData(
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

class CustomTheme extends StatefulWidget {
  final ThemeData themeData;
  final Widget child;

  const CustomTheme({Key? key, required this.themeData, required this.child}) : super(key: key);

  @override
  CustomThemeState createState() => CustomThemeState();
}

class CustomThemeState extends State<CustomTheme> {
  ThemeData themeData = AppTheme.lightTheme;

  void switchTheme() {
    setState(() =>
        themeData = themeData == AppTheme.darkTheme ? AppTheme.lightTheme : AppTheme.darkTheme);
  }

  @override
  Widget build(BuildContext context) {
    return InheritedCustomTheme(
      themeData: widget.themeData,
      child: widget.child,
      state: this,
    );
  }
}

class InheritedCustomTheme extends InheritedWidget {
  final ThemeData themeData;
  final CustomThemeState state;

  InheritedCustomTheme(
      {required this.themeData, required this.state, Key? key, required Widget child})
      : super(
          key: key,
          child: child,
        );

  static CustomThemeState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<InheritedCustomTheme>()!.state;

  @override
  bool updateShouldNotify(InheritedCustomTheme oldWidget) => true;
}
