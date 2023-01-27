import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'presentation/app/chat_journal.dart';
import 'repository/anonymous_auth.dart';
import 'repository/shared_pref_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SharedPreferencesServices.initialize();
  final _user = await AuthService().signInAnonymous();

  runApp(
    ChatJournal(
      curUser: _user,
    ),
  );
}
