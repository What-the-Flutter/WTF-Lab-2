import 'package:flutter/material.dart';

import 'initial_settings_func.dart';
import 'ui/screens/home/init.dart';

void main() async {
  final initial = await init();

  runApp(
    BlocsProvider(
      user: initial['user']!,
      initTheme: initial['initTheme'],
      initFontSize: initial['initFontSize'],
      isChatBubblesToRight: initial['isChatBubblesToRight'],
      backgroundImagePath: initial['backgroundImage'],
    ),
  );
}


