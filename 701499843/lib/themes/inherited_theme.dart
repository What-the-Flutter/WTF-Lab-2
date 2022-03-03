import 'package:flutter/material.dart';
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

  void changeTheme() {
    setState(
      () {
        if (themeData == CustomTheme.lightTheme) {
          themeData = CustomTheme.darkTheme;
        } else {
          themeData = CustomTheme.lightTheme;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Inherited(
      themeData: themeData,
      child: widget.child,
      state: this,
    );
  }
}
