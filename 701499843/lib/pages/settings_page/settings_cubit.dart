import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../themes/theme.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit()
      : super(
          SettingsState(
            currentTheme: CustomTheme.lightTheme,
          ),
        );

  void loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString('theme') ?? '';
    ThemeData themeData;
    if (theme == 'light' || theme == '') {
      themeData = CustomTheme.lightTheme;
    } else {
      themeData = CustomTheme.darkTheme;
    }

    emit(
      state.copyWith(currentTheme: themeData),
    );
  }

  void changeTheme() async {
    final prefs = await SharedPreferences.getInstance();
    if (state.currentTheme == CustomTheme.lightTheme) {
      emit(
        state.copyWith(currentTheme: CustomTheme.darkTheme),
      );
      prefs.setString('theme', 'dark');
    } else {
      emit(
        state.copyWith(currentTheme: CustomTheme.lightTheme),
      );
      prefs.setString('theme', 'light');
    }
  }
}
