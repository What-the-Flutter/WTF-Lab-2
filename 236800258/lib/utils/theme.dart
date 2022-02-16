import 'package:flutter/material.dart';

import 'constants.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    colorSchemeSeed: CustomColors.primaryColor,
    listTileTheme: ListTileThemeData(
      tileColor: CustomColors.listTileColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7),
      ),
    ),
    primaryColorDark: CustomColors.primaryDarkColor,
  );
}
