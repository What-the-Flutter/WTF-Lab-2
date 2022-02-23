import 'package:flutter/material.dart';

class MyThemes {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: Colors.green,
    brightness: Brightness.light,
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: Colors.grey,
    brightness: Brightness.dark,
  );
}

class CustomTheme extends StatefulWidget {
  final ThemeData themeData;
  final Widget child;

  const CustomTheme({Key? key, required this.themeData, required this.child})
      : super(key: key);

  @override
  CustomThemeState createState() => CustomThemeState();
}

class CustomThemeState extends State<CustomTheme> {
  ThemeData themeData = MyThemes.lightTheme;

  void switchTheme() {
    setState(() => themeData = themeData == MyThemes.darkTheme
        ? MyThemes.lightTheme
        : MyThemes.darkTheme);
  }

  @override
  Widget build(BuildContext context) => InheritedCustomTheme(
        themeData: widget.themeData,
        child: widget.child,
        state: this,
      );
}

class InheritedCustomTheme extends InheritedWidget {
  final ThemeData themeData;
  final CustomThemeState state;

  InheritedCustomTheme(
      {required this.themeData,
      required this.state,
      Key? key,
      required Widget child})
      : super(key: key, child: child);

  static CustomThemeState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<InheritedCustomTheme>()!.state;

  @override
  bool updateShouldNotify(InheritedCustomTheme oldWidget) => true;
}
