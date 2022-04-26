import 'package:flutter/material.dart';

class SettingsState {
  final ThemeData theme;
  final bool useBiometrics;

  SettingsState({
    required this.theme,
    required this.useBiometrics,
  });

  SettingsState copyWith({
    ThemeData? theme,
    bool? useBiometrics,
  }) {
    return SettingsState(
      theme: theme ?? this.theme,
      useBiometrics: useBiometrics ?? this.useBiometrics,
    );
  }
}
