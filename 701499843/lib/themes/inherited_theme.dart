import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme.dart';

class Inherited extends InheritedWidget {
  final ThemeData themeData;
  final AppThemeProviderState state;

  Inherited({
    Key? key,
    required Widget child,
    required this.themeData,
    required this.state,
  }) : super(key: key, child: child);

  static AppThemeProviderState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<Inherited>()!.state;

  @override
  bool updateShouldNotify(Inherited oldWidget) => true;
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
  ThemeData themeData = CustomTheme.lightTheme;

  void loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString('theme') ?? '';

    setState(
      () {
        if (theme == 'light' || theme == '') {
          themeData = CustomTheme.lightTheme;
        } else {
          themeData = CustomTheme.darkTheme;
        }
      },
    );
  }

  void changeTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(
      () {
        if (themeData == CustomTheme.lightTheme) {
          themeData = CustomTheme.darkTheme;
          prefs.setString('theme', 'dark');
        } else {
          themeData = CustomTheme.lightTheme;
          prefs.setString('theme', 'light');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    loadTheme();
    return Inherited(
      themeData: themeData,
      child: widget.child,
      state: this,
    );
  }
}
