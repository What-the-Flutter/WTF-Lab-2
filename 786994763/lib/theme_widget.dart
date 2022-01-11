import 'package:flutter/material.dart';

import 'models/themes.dart';

class _ThemeInheritedWidget extends InheritedWidget {
  final _ThemeWidgetState stateWidget;

  const _ThemeInheritedWidget({
    Key? key,
    required Widget child,
    required this.stateWidget,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_ThemeInheritedWidget oldWidget) => true;
}

class ThemeWidget extends StatefulWidget {
  final Widget child;
  final ThemeKeys initialThemeKey;

  const ThemeWidget({
    Key? key,
    required this.child,
    required this.initialThemeKey,
  }) : super(key: key);

  @override
  _ThemeWidgetState createState() => _ThemeWidgetState();

  static ThemeData of(BuildContext context) {
    var inherited =
        (context.dependOnInheritedWidgetOfExactType<_ThemeInheritedWidget>()!);
    return inherited.stateWidget.getTheme;
  }

  static _ThemeWidgetState instanceOf(BuildContext context) {
    var inherited =
        (context.dependOnInheritedWidgetOfExactType<_ThemeInheritedWidget>()!);
    return inherited.stateWidget;
  }
}

class _ThemeWidgetState extends State<ThemeWidget> {
  late ThemeData _theme;
  bool currentTheme = true;

  ThemeData get getTheme => _theme;

  @override
  void initState() {
    _theme = Themes.getThemeByKey(widget.initialThemeKey);
    super.initState();
  }

  void setTheme(ThemeKeys value) {
    currentTheme
        ? setState(() => _theme = Themes.getThemeByKey(ThemeKeys.dark))
        : setState(() => _theme = Themes.getThemeByKey(ThemeKeys.light));
    currentTheme ? currentTheme = false : currentTheme = true;
  }

  @override
  Widget build(BuildContext context) {
    return _ThemeInheritedWidget(
      child: widget.child,
      stateWidget: this,
      key: UniqueKey(),
    );
  }
}
