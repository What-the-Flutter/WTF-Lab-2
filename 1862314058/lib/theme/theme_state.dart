import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_cubit.dart';

class ThemeState {
  final bool? isLightTheme;
  final ThemeData? appThemes;
  final TextTheme? textTheme;

  ThemeState({
    this.isLightTheme,
    this.appThemes,
    this.textTheme,
  });

  ThemeState copyWith({
    final bool? isLightTheme,
    final ThemeData? appThemes,
    final TextTheme? textTheme,
  }) {
    return ThemeState(
      isLightTheme: isLightTheme ?? this.isLightTheme,
      appThemes: appThemes ?? this.appThemes,
      textTheme: textTheme ?? this.textTheme,
    );
  }


  ThemeState get lightTheme {
    return ThemeState(
      isLightTheme: true,
      appThemes: ThemeData(
        primaryColor: Colors.green,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: const ColorScheme.light(),
        iconTheme: const IconThemeData(color: Colors.green),
        textTheme: textTheme,
      ),
    );
  }

  ThemeState get darkTheme {
    return ThemeState(
      isLightTheme: false,
      appThemes: ThemeData(
        primaryColor: Colors.grey.shade900,
        scaffoldBackgroundColor: Colors.grey.shade900,
        colorScheme: const ColorScheme.dark(),
        iconTheme: const IconThemeData(color: Colors.yellow),
        textTheme: textTheme,
      ),
    );
  }



  static const TextTheme largeTextTheme = TextTheme(
    headline1: TextStyle(
      fontSize: 22,
    ),
    headline2: TextStyle(
      fontSize: 22,
    ),
    headline3: TextStyle(
      fontSize: 22,
    ),
    headline4: TextStyle(
      fontSize: 22,
    ),
    headline5: TextStyle(
      fontSize: 22,
    ),
    headline6: TextStyle(
      fontSize: 22,
    ),
    subtitle1: TextStyle(
      fontSize: 16,
    ),
    subtitle2: TextStyle(
      fontSize: 16,
    ),
    bodyText1: TextStyle(
      fontSize: 18,
    ),
    bodyText2: TextStyle(
      fontSize: 18,
    ),
  );

  static const TextTheme defaultTextTheme = TextTheme(
    headline1: TextStyle(
      fontSize: 20,
    ),
    headline2: TextStyle(
      fontSize: 20,
    ),
    headline3: TextStyle(
      fontSize: 20,
    ),
    headline4: TextStyle(
      fontSize: 20,
    ),
    headline5: TextStyle(
      fontSize: 20,
    ),
    headline6: TextStyle(
      fontSize: 20,
    ),
    subtitle1: TextStyle(
      fontSize: 14,
    ),
    subtitle2: TextStyle(
      fontSize: 14,
    ),
    bodyText1: TextStyle(
      fontSize: 16,
    ),
    bodyText2: TextStyle(
      fontSize: 16,
    ),
  );

  static const TextTheme smallTextTheme = TextTheme(
    headline1: TextStyle(
      fontSize: 16,
    ),
    headline2: TextStyle(
      fontSize: 16,
    ),
    headline3: TextStyle(
      fontSize: 16,
    ),
    headline4: TextStyle(
      fontSize: 16,
    ),
    headline5: TextStyle(
      fontSize: 16,
    ),
    headline6: TextStyle(
      fontSize: 16,
    ),
    subtitle1: TextStyle(
      fontSize: 12,
    ),
    subtitle2: TextStyle(
      fontSize: 12,
    ),
    bodyText1: TextStyle(
      fontSize: 14,
    ),
    bodyText2: TextStyle(
      fontSize: 14,
    ),
  );

}
