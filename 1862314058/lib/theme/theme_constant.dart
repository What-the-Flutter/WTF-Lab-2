import 'package:flutter/material.dart';

enum ThemeTypes { light, dark, darker }

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.green
  );

  static final ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.black87
  );
}
