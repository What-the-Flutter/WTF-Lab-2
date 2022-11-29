import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final preferences = ThemePreferences();

  ThemeCubit() : super(ThemeState());

  void init() async {
    final themeData = await preferences.getTheme();
    emit(ThemeState(themeMode: themeData));
  }

  void changeTheme() {
    final newThemeMode =
        state.themeMode.name == 'dark' ? ThemeMode.light : ThemeMode.dark;
    preferences.saveTheme(newThemeMode);
    emit(ThemeState(themeMode: newThemeMode));
  }
}

class ThemeState {
  final ThemeMode themeMode;

  ThemeState({this.themeMode = ThemeMode.light});
}

class ThemePreferences {
  static const _themeMode = 'themeMode';

  Future saveTheme(ThemeMode themeMode) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString(_themeMode, themeMode.name);
  }

  Future<ThemeMode> getTheme() async {
    final preferences = await SharedPreferences.getInstance();
    final themeMode = preferences.getString(_themeMode);
    if(themeMode == null){
      return ThemeMode.system;
    }
    return themeMode == 'light' ? ThemeMode.light : ThemeMode.dark;
  }
}
