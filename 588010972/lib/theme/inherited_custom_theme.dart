import 'package:flutter/material.dart';

import 'custom_theme.dart';

class CustomThemeInherited extends InheritedWidget {
  final CustomThemeState themeState;

  @override
  final Widget child;


  const CustomThemeInherited({Key? key,
    required this.child,
    required this.themeState})
      : super(key: key, child: child);


  @override
  bool updateShouldNotify(CustomThemeInherited oldWidget) {
    return true;
  }
}