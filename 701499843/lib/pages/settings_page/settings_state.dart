import 'package:flutter/material.dart';

class SettingsState {
  final ThemeData currentTheme;

  SettingsState({required this.currentTheme});

  SettingsState copyWith({ThemeData? currentTheme}) {
    return SettingsState(currentTheme: currentTheme ?? this.currentTheme);
  }
}
