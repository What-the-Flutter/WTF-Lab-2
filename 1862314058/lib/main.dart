import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'presentation/app/chat_journal.dart';
import 'repository/anonymous_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final currentUser = await AuthService().signInAnonymous();

  runApp(
    ChatJournal(
      user: currentUser,
    ),
  );
}
