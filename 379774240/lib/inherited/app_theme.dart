import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppThemeState extends StatefulWidget {
  final Widget child;

  const AppThemeState({
    super.key,
    required this.child,
  });

  @override
  State<AppThemeState> createState() => _AppThemeStateState();
}

class _AppThemeStateState extends State<AppThemeState> {
  late bool isLightTheme = true;

  @override
  void initState() {
    _setTheme();
    super.initState();
  }

  void swichTheme() {
    final isLightTheme = this.isLightTheme == true ? false : true;
    _saveTheme(isLightTheme);
    setState(() => this.isLightTheme = isLightTheme);
  }

  Future<void> _setTheme() async {
    final pref = await SharedPreferences.getInstance();
    var theme = await pref.getBool('appTheme');
    setState(() {
      isLightTheme = theme ?? true;
    });
    print('Theme initilaized');
  }

  Future<void> _saveTheme(bool isLightTheme) async {
    final pref = await SharedPreferences.getInstance();
    pref.setBool('appTheme', isLightTheme);
    print('Theme saved');
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeInheritedWidget(
      child: widget.child,
      isLightTheme: isLightTheme,
      stateWidget: this,
    );
  }
}

class AppThemeInheritedWidget extends InheritedWidget {
  final bool isLightTheme;
  final _AppThemeStateState stateWidget;

  AppThemeInheritedWidget({
    super.key,
    required super.child,
    required this.isLightTheme,
    required this.stateWidget,
  });

  static _AppThemeStateState of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AppThemeInheritedWidget>()!
        .stateWidget;
  }

  @override
  bool updateShouldNotify(AppThemeInheritedWidget oldWidget) {
    return oldWidget.isLightTheme != isLightTheme;
  }
}
