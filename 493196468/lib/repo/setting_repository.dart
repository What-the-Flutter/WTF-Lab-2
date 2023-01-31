import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../presentation/settings/cubit/settings_cubit/settings_cubit.dart';
import '../presentation/settings/theme.dart';

class SettingsRepository {
  static const _themeMode = 'themeMode';
  static const _bubbleAlignment = 'bubbleAlignment';
  static const _centerDateAlignment = 'centerDateAlignment';
  static const _textSize = 'textSize';

  final SharedPreferences preferences;

  SettingsRepository({required this.preferences});

  Future saveTheme(ThemeMode themeMode) async {
    preferences.setString(_themeMode, themeMode.name);
  }

  Future<ThemeMode> getTheme() async {
    final themeMode = preferences.getString(_themeMode);
    if (themeMode == null) {
      return ThemeMode.light;
    }
    return themeMode == 'light' ? ThemeMode.light : ThemeMode.dark;
  }

  Future saveAlignment(BubbleAlignment bubbleAlignment) async {
    final alignmentStr =
    BubbleAlignment.left == bubbleAlignment ? 'left' : 'right';
    preferences.setString(_bubbleAlignment, alignmentStr);
  }

  Future<BubbleAlignment> getAlignment() async {
    final alignmentStr = preferences.getString(_bubbleAlignment);
    if (alignmentStr == null) {
      return BubbleAlignment.left;
    }
    return alignmentStr == 'left'
        ? BubbleAlignment.left
        : BubbleAlignment.right;
  }

  Future saveCenterBubble(bool isCenterAlignment) async {
    preferences.setBool(_centerDateAlignment, isCenterAlignment);
  }

  Future<bool> getCenterBubble() async {
    return preferences.getBool(_centerDateAlignment) ?? true;
  }

  void saveTextSize(TextSizeKeys textSize) async {
    final String textSizeStr;
    switch (textSize) {
      case TextSizeKeys.small:
        textSizeStr = 'small';
        break;
      case TextSizeKeys.medium:
        textSizeStr = 'medium';
        break;
      case TextSizeKeys.large:
        textSizeStr = 'large';
        break;
    }
    preferences.setString(_textSize, textSizeStr);
  }

  Future<TextSizeKeys> getFontSize() async {
    switch (preferences.getString(_textSize)) {
      case 'small':
        return TextSizeKeys.small;
      case 'medium':
        return TextSizeKeys.medium;
      case 'large':
        return TextSizeKeys.large;
      default:
        return TextSizeKeys.medium;
    }
  }
}
