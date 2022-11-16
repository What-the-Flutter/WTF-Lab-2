import 'package:flutter/material.dart';

import 'theme_constant.dart';

class ThemeHandler with ChangeNotifier {
  ThemeMode themeMode = ThemeMode.dark;

  void toggleTheme(bool isDark) {
    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
