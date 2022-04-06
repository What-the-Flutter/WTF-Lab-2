import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'services/anon_auth.dart';
import 'ui/widgets/init.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final prefs = await SharedPreferences.getInstance();
  final _initTheme = await prefs.getString('theme') ?? 'light';
  final _user = await AuthService().singIn();
  await FirebaseDatabase.instance
      .ref()
      .child(_user!.uid)
      .child('auth')
      .set(false);

  runApp(
    BlocInit(user: _user, initTheme: _initTheme),
  );
}
