import 'package:flutter/material.dart';


import '../../theme/theme_constant.dart';
import 'app_page.dart';

class ChatJournal extends StatelessWidget {
  const ChatJournal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      home: const AppPage(title: 'Home'),
    );
  }
}
