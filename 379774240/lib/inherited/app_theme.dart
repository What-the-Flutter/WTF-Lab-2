import 'package:flutter/material.dart';

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
  bool isLightTheme = true;

  void swichTheme() {
    final isLightTheme = this.isLightTheme == true ? false : true;

    setState(() => this.isLightTheme = isLightTheme);
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
