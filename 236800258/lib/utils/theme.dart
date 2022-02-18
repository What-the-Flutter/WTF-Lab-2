import 'package:flutter/material.dart';

import 'constants/colors.dart';

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
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
      ),
      iconTheme: const IconThemeData(color: CustomColors.lightIconColor)
  );
}
