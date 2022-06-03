import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'package:diploma/data_base/shared_preferences_provider.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final SharedPreferencesProvider _prefs;

  ThemeCubit(this._prefs) : super(ThemeState(_prefs.getTheme()));

  void changeTheme() {
    _prefs.changeTheme();
    emit(state.copyWith(_prefs.getTheme()));
  }
}
