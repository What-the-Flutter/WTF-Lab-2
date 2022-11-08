import 'package:flutter/material.dart';

import 'package:diary/repo/chats/chat_list_preferences.dart';
import 'package:diary/repo/messages/message_list_preferences.dart';
import 'package:bloc/bloc.dart';
import 'blocs_observer.dart';
import 'chat_diary_app.dart';
import 'themes/theme_changer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = BlocsObserver();
  await ChatListPreferences.init();
  await MessageListPreferences.init();
  //await ChatListPreferences.delete();
  //await MessageListPreferences.delete();
  runApp(
    StateChanger(
      child: ChatDiaryApp(),
    ),
  );
}