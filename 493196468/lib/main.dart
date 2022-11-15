import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'blocs_observer.dart';
import 'chat_diary_app.dart';
import 'themes/theme_changer.dart';

Future<void> main() async {
  Bloc.observer = BlocsObserver();
  runApp(
    const ThemeStateChanger(
      child: ChatDiaryApp(),
    ),
  );
}