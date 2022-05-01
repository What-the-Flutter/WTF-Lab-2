import 'package:flutter/cupertino.dart';

class AppColors {
  static const Color primaryColor = Color(0xFFF5F4F2);
  static const Color supportingColor = Color(0xFF82736C);
  static const Color textColor = Color(0xFF1B1714);
  static const Color detailsColor = Color(0xFFE0AA7C);
}

class AppFonts {
  static const double fontSize = 18.0;

  static const TextStyle defaultTextStyle = TextStyle(
    fontSize: fontSize,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w400,
    color: AppColors.textColor,
  );
  static const TextStyle headerTextStyle = TextStyle(
    fontSize: fontSize * 1.5,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w400,
    color: AppColors.textColor,
  );
  static const TextStyle navBarTextStyle = TextStyle(
    fontSize: 40,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w400,
    color: AppColors.textColor,
  );
}

class AppDecorators {
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 16.0;
}
