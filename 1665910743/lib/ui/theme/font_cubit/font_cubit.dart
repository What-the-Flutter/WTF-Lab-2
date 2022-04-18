import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme_data.dart';

class FontCubit extends Cubit<TextTheme> {
  final TextTheme initSize;

  FontCubit({required this.initSize}) : super(initSize);

  Future<void> fontChange(MyFontSize size) async {
    final _prefs = await SharedPreferences.getInstance();

    switch (size) {
      case MyFontSize.small:
        _prefs.setString('font', 'small');
        emit(FontSize.small);
        break;
      case MyFontSize.medium:
        _prefs.setString('font', 'medium');

        emit(FontSize.medium);
        break;
      case MyFontSize.large:
        _prefs.setString('font', 'large');

        emit(FontSize.large);
        break;
    }
  }
}
