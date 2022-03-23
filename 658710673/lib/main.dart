import 'package:flutter/material.dart';

import 'pages/home_page.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(
    CustomTheme(
      themeData: AppTheme.lightTheme,
      child: const ChatJournalApp(),
    ),
  );
}
