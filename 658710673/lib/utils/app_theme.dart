import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

enum ThemeKeys { light, dark }

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
  final Widget child;

  const CustomTheme({Key? key, required this.child}) : super(key: key);

  @override
  CustomThemeState createState() => CustomThemeState();
}

class CustomThemeState extends State<CustomTheme> {
  ThemeData themeData = AppTheme.lightTheme;

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString('theme') ?? ThemeKeys.light.toString();

    setState(
      () {
        if (theme == ThemeKeys.light.toString()) {
          themeData = AppTheme.lightTheme;
        } else {
          themeData = AppTheme.darkTheme;
        }
      },
    );
  }

  void switchTheme(ThemeKeys themeKey) async {
    final _prefs = await SharedPreferences.getInstance();
    if (themeKey == ThemeKeys.light) {
      _prefs.setString('theme', ThemeKeys.light.toString());
      setState(() => themeData = AppTheme.lightTheme);
    } else {
      _prefs.setString('theme', ThemeKeys.dark.toString());
      setState(() => themeData = AppTheme.darkTheme);
    }
  }

  @override
  Widget build(BuildContext context) {
    _loadTheme();
    return InheritedCustomTheme(
      themeData: themeData,
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
