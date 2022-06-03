import 'package:flutter/material.dart';

enum FontSize { small, medium, large }

class SettingsState {
  final ThemeData currentTheme;
  final TextTheme textTheme;
  final bool bubbleAlignment;
  final bool centerDate;

  ThemeData get lightTheme {
    return ThemeData(
      primaryColor: Colors.teal,
      hintColor: Colors.black,
      scaffoldBackgroundColor: Colors.white,
      shadowColor: Colors.grey[200],
      backgroundColor: Colors.black,
      highlightColor: Colors.white,
      primaryIconTheme: const IconThemeData(color: Colors.white),
      colorScheme: ColorScheme.light(
          secondary: Colors.teal, primary: Colors.green[100]!),
      textTheme: textTheme,
    );
  }

  ThemeData get darkTheme {
    return ThemeData(
      primaryColor: Colors.black,
      highlightColor: Colors.white,
      hintColor: Colors.white,
      backgroundColor: Colors.white,
      scaffoldBackgroundColor: Colors.black,
      primaryIconTheme: const IconThemeData(color: Colors.black),
      colorScheme: ColorScheme.dark(
          secondary: Colors.yellow, primary: Colors.yellow[100]!),
      bottomAppBarColor: Colors.black87,
      shadowColor: Colors.black87,
      textTheme: textTheme,
    );
  }

  static const TextTheme large = TextTheme(
    subtitle1: TextStyle(
      fontSize: 19,
    ),
    bodyText2: TextStyle(
      fontSize: 16,
    ),
    bodyText1: TextStyle(
      fontSize: 18,
    ),
  );

  static const TextTheme medium = TextTheme(
    subtitle1: TextStyle(
      fontSize: 14,
    ),
    bodyText2: TextStyle(
      fontSize: 12,
    ),
    bodyText1: TextStyle(
      fontSize: 13,
    ),
  );

  static const TextTheme small = TextTheme(
    subtitle1: TextStyle(
      fontSize: 12,
    ),
    bodyText2: TextStyle(
      fontSize: 10,
    ),
    bodyText1: TextStyle(
      fontSize: 11,
    ),
  );

  SettingsState({
    required this.currentTheme,
    required this.textTheme,
    required this.bubbleAlignment,
    required this.centerDate,
  });

  SettingsState copyWith({
    ThemeData? currentTheme,
    TextTheme? textTheme,
    bool? bubbleAlignment,
    bool? centerDate,
  }) {
    return SettingsState(
      currentTheme: currentTheme ?? this.currentTheme,
      textTheme: textTheme ?? this.textTheme,
      bubbleAlignment: bubbleAlignment ?? this.bubbleAlignment,
      centerDate: centerDate ?? this.centerDate,
    );
  }
}
