import 'package:flutter/material.dart';

class ThemeState{
  final ThemeData theme;

  ThemeState(this.theme);

  ThemeState copyWith(ThemeData newTheme){
    return ThemeState(newTheme);
  }
}