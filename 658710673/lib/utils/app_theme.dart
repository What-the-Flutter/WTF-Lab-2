import 'package:flutter/material.dart';

import 'constants.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: Constants.secondaryColor,
      fontFamily: 'Montserrat',
      colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Constants.primaryColor, secondary: Constants.secondaryColor),
      appBarTheme: const AppBarTheme(
        backgroundColor: Constants.primaryColor,
        foregroundColor: Constants.iconColor,
      ),
    );
  }
}
