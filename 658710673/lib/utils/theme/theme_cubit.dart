import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/shared_preferences_provider.dart';
import 'app_theme.dart';

class ThemeCubit extends Cubit<ThemeData> {
  final ThemeData initTheme;

  ThemeCubit(this.initTheme) : super(initTheme);

  void changeTheme(ThemeKeys themeKey) async {
    final _prefs = SharedPreferencesProvider();
    if (themeKey == ThemeKeys.light) {
      emit(AppTheme.lightTheme);
      _prefs.changeTheme(ThemeKeys.light);
    } else {
      emit(AppTheme.darkTheme);
      _prefs.changeTheme(ThemeKeys.dark);
    }
  }
}
