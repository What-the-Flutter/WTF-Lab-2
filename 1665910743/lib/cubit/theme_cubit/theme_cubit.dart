import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ui/theme/theme_data.dart';

class ThemeCubit extends Cubit<ThemeData> {
  final ThemeData initTheme;
  ThemeCubit(this.initTheme) : super(initTheme);

  void themeChanged(MyThemeKeys themeKey) async {
    final _prefs = await SharedPreferences.getInstance();
    if (themeKey == MyThemeKeys.light) {
      _prefs.setString('theme', 'light');
      emit(MyThemes.lightTheme);
    } else {
      _prefs.setString('theme', 'dark');
      emit(MyThemes.darkTheme);
    }
  }
}
