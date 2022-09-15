import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../themes/themeData/dark_theme.dart';
import '../../themes/themeData/light_theme.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final _prefs = SharedPreferences.getInstance();

  SettingsCubit(super.settingsState);

  Future swithTheme() async {
    var prefs = await _prefs;
    var isDarkTheme = state.isDarkTheme ? false : true;
    await prefs.setBool('isDarkTheme', isDarkTheme);
    emit(state.copyWith(isDarkTheme: isDarkTheme));
  }

  Future alignMessageLeft() async {
    var prefs = await _prefs;
    var isMessageLeftAlign = state.isMessageLeftAlign ? false : true;
    await prefs.setBool('isMessageLeftAlign', isMessageLeftAlign);
    emit(state.copyWith(isMessageLeftAlign: isMessageLeftAlign));
  }

  Future hideDateBublle() async {
    var prefs = await _prefs;
    var isDateBubbleHiden = state.isDateBubbleHiden ? false : true;
    await prefs.setBool('isDateBubbleHiden', isDateBubbleHiden);
    emit(state.copyWith(isDateBubbleHiden: isDateBubbleHiden));
  }

  Future setDefaultSettings() async {
    var prefs = await _prefs;

    await prefs.setBool('isDarkTheme', defaultSettings['isDarkTheme']);
    await prefs.setBool(
        'isMessageLeftAlign', defaultSettings['isMessageLeftAlign']);
    await prefs.setBool(
        'isDateBubbleHiden', defaultSettings['isDateBubbleHiden']);
    await prefs.setDouble('fontSize', defaultSettings['fontSize']);

    emit(state.copyWith(
      isDarkTheme: defaultSettings['isDarkTheme'],
      isMessageLeftAlign: defaultSettings['isMessageLeftAlign'],
      isDateBubbleHiden: defaultSettings['isDateBubbleHiden'],
      fontSize: defaultSettings['fontSize'],
    ));
  }

  Future setFontSize(int value) async {
    var prefs = await _prefs;
    var fontSizes = [16.0, 18.0, 20.0];

    switch (value) {
      case 0:
        await prefs.setDouble('fontSize', fontSizes[value]);
        emit(state.copyWith(fontSize: fontSizes[value]));
        break;
      case 1:
        await prefs.setDouble('fontSize', fontSizes[value]);
        emit(state.copyWith(fontSize: fontSizes[value]));
        break;
      case 2:
        await prefs.setDouble('fontSize', fontSizes[value]);
        emit(state.copyWith(fontSize: fontSizes[value]));
        break;
      default:
        await prefs.setDouble('fontSize', defaultSettings['fontSize']);
        emit(state.copyWith(fontSize: defaultSettings['fontSize']));
        break;
    }
  }

  ThemeData fetchTheme() {
    var dark = darkThemeData.copyWith(
      textTheme: TextTheme(
        bodyMedium: TextStyle(fontSize: state.fontSize),
      ),
    );
    var light = lightThemeData.copyWith(
      textTheme: TextTheme(
        bodyMedium: TextStyle(fontSize: state.fontSize),
      ),
    );
    return state.isDarkTheme ? dark : light;
  }

  int fetchSliderIndex() {
    switch (state.fontSize.toInt()) {
      case 16:
        return 0;
      case 18:
        return 1;
      case 20:
        return 2;
      default:
        return 0;
    }
  }
}

Map<String, dynamic> defaultSettings = {
  'isDarkTheme': false,
  'isMessageLeftAlign': false,
  'isDateBubbleHiden': false,
  'fontSize': 16.0,
};
