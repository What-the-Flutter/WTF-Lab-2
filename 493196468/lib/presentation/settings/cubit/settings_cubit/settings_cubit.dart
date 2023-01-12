import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../theme.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final _themePrefs = ThemePreferences();
  final _alignmentPrefs = AlignmentPreferences();
  final _textSizePrefs = TextSizePreferences();
  final _centerDatePrefs = CenterDateAlignmentPreferences();

  SettingsCubit() : super(SettingsState()) {
    _init();
  }

  void _init() async {
    final themeData = await _themePrefs.getTheme();
    final bubbleAlignment = await _alignmentPrefs.getAlignment();
    final textSize = await _textSizePrefs.getFontSize();
    final isCenterDateAlignment = await _centerDatePrefs.getAlignment();
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
    _themePrefs.saveTheme(newThemeMode);
    emit(state.copyWith(themeMode: newThemeMode));
  }

  void changeAlignment() {
    final newAlignment = state.bubbleAlignment == BubbleAlignment.left
        ? BubbleAlignment.right
        : BubbleAlignment.left;
    _alignmentPrefs.saveAlignment(newAlignment);
    emit(state.copyWith(bubbleAlignment: newAlignment));
  }

  void changeDateBubbleAlignment() {
    final isCenter = !state.isCenterDateAlignment;
    _centerDatePrefs.saveAlignment(isCenter);
    emit(state.copyWith(isCenterDateAlignment: isCenter));
  }

  void changeTextSize(TextSizeKeys textSize) {
    switch (textSize) {
      case TextSizeKeys.small:
        emit(state.copyWith(textSize: TextSizeKeys.small));
        _textSizePrefs.saveTextSize(TextSizeKeys.small);
        break;
      case TextSizeKeys.medium:
        emit(state.copyWith(textSize: TextSizeKeys.medium));
        _textSizePrefs.saveTextSize(TextSizeKeys.medium);
        break;
      case TextSizeKeys.large:
        emit(state.copyWith(textSize: TextSizeKeys.large));
        _textSizePrefs.saveTextSize(TextSizeKeys.large);
        break;
    }
  }

  void toDefaultSettings() {
    emit(SettingsState());
  }
}
