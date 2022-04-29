import 'package:flutter/material.dart';

class MyTheme {
  ThemeData themeData;
  var isLight = true;

  MyTheme(this.themeData);
}

class GeneralTheme extends InheritedWidget {
  final MyTheme myTheme;

  const GeneralTheme({
    Key? key,
    required this.myTheme,
    required Widget child,
  }) : super(key: key, child: child);

  static GeneralTheme of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<GeneralTheme>();
    assert(result != null, 'No GeneralTheme found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(GeneralTheme oldWidget) =>
      myTheme != oldWidget.myTheme;
}
