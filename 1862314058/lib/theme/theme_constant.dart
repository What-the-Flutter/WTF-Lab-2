import 'package:flutter/material.dart';

enum ThemeTypes { light, dark, darker}


ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.green
);

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
  primaryColor: Colors.black87
);