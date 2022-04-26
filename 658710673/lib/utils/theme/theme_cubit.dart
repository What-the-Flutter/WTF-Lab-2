import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_theme.dart';

class ThemeCubit extends Cubit<ThemeData> {
  final ThemeData initTheme;

  ThemeCubit(this.initTheme) : super(initTheme);

  void changeTheme(ThemeKeys themeKey) async {
    final _prefs = await SharedPreferences.getInstance();
    if (themeKey == ThemeKeys.light) {
      emit(AppTheme.lightTheme);
      _prefs.setString('theme', ThemeKeys.light.toString());
    } else {
      emit(AppTheme.darkTheme);
      _prefs.setString('theme', ThemeKeys.dark.toString());
    }
  }
}
