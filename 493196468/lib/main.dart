import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'blocs_observer.dart';
import 'firebase_options.dart';
import 'presentation/chat_diary_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = BlocsObserver();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final isSignedIn = await _anonymousAuth();
  final preferences = await SharedPreferences.getInstance();

  runApp(
    ChatDiaryApp(
      isSignedIn: isSignedIn,
      preferences: preferences,
    ),
  );
}

Future<bool> _anonymousAuth() async {
  try {
    final userCredential = await FirebaseAuth.instance.signInAnonymously();
    print('Signed in with UID: ${userCredential.user?.uid}');
    return true;
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case 'operation-not-allowed':
        return false;
      default:
        return false;
    }
  }
}
