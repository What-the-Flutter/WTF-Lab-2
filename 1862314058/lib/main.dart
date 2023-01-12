import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'presentation/app/chat_journal.dart';
import 'repository/anonymous_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  final _user = await AuthService().signInAnonymous();

  runApp(
    ChatJournal(
      curUser: _user,
      sharPref: _prefs,
    ),
  );
}
