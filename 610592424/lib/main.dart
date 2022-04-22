import 'package:flutter/material.dart';
import 'Home/Screens/event_holders_screen.dart';
import 'Home/Additional/theme_widget.dart';

void main() {
  runApp(
    GeneralTheme(
      myTheme: MyTheme(ThemeData.light()),
      child: const MaterialApp(
        title: "Diploma project",
        home: EventHoldersScreen(),
      ),
    ),
  );
}
