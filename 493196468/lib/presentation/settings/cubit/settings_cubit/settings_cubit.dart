import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../repo/setting_repository.dart';
import '../../theme.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository _settingsPrefs;

  SettingsCubit(this._settingsPrefs) : super(SettingsState()) {
    _init(_settingsPrefs);
  }

  void _init(SettingsRepository _settingsPrefs) async {
    final themeData = await _settingsPrefs.getTheme();
    final bubbleAlignment = await _settingsPrefs.getAlignment();
    final textSize = await _settingsPrefs.getFontSize();
    final isCenterDateAlignment = await _settingsPrefs.getCenterBubble();
    emit(
      SettingsState(
        themeMode: themeData,
        bubbleAlignment: bubbleAlignment,
        textSize: textSize,
        isCenterDateAlignment: isCenterDateAlignment,
      ),
    );
  }

  @override
  String toString() {
    return state.textSize.toString();
  }

  void changeTheme() {
    final newThemeMode =
        state.themeMode.name == 'dark' ? ThemeMode.light : ThemeMode.dark;
    _settingsPrefs.saveTheme(newThemeMode);
    emit(state.copyWith(themeMode: newThemeMode));
  }

  void changeAlignment() {
    final newAlignment = state.bubbleAlignment == BubbleAlignment.left
        ? BubbleAlignment.right
        : BubbleAlignment.left;
    _settingsPrefs.saveAlignment(newAlignment);
    emit(state.copyWith(bubbleAlignment: newAlignment));
  }

  void changeDateBubbleAlignment() {
    final isCenter = !state.isCenterDateAlignment;
    _settingsPrefs.saveCenterBubble(isCenter);
    emit(state.copyWith(isCenterDateAlignment: isCenter));
  }

  void changeTextSize(TextSizeKeys textSize) {
    switch (textSize) {
      case TextSizeKeys.small:
        emit(state.copyWith(textSize: TextSizeKeys.small));
        _settingsPrefs.saveTextSize(TextSizeKeys.small);
        break;
      case TextSizeKeys.medium:
        emit(state.copyWith(textSize: TextSizeKeys.medium));
        _settingsPrefs.saveTextSize(TextSizeKeys.medium);
        break;
      case TextSizeKeys.large:
        emit(state.copyWith(textSize: TextSizeKeys.large));
        _settingsPrefs.saveTextSize(TextSizeKeys.large);
        break;
    }
  }

  void toDefaultSettings() {
    emit(SettingsState());
  }
}
