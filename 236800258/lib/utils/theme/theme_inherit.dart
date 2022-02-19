import 'package:flutter/material.dart';

import 'app_theme.dart';

class ThemeInherit extends InheritedWidget {
  final ThemeData themeData;
  final AppThemeProviderState state;

  ThemeInherit({
    Key? key,
    required Widget child,
    required this.themeData,
    required this.state,
  }) : super(key: key, child: child);

  static AppThemeProviderState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ThemeInherit>()!.state;

  @override
  bool updateShouldNotify(ThemeInherit oldWidget) => true;
}

class AppThemeProvider extends StatefulWidget {
  final Widget child;

  const AppThemeProvider({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  AppThemeProviderState createState() => AppThemeProviderState();
}

class AppThemeProviderState extends State<AppThemeProvider> {
  ThemeData themeData = AppTheme.lightTheme;

  void changeTheme() {
    setState(() {
      if (themeData == AppTheme.lightTheme) {
        themeData = AppTheme.darkTheme;
      } else {
        themeData = AppTheme.lightTheme;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ThemeInherit(
      themeData: themeData,
      child: widget.child,
      state: this,
    );
  }
}
