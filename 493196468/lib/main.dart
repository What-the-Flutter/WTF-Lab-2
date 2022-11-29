import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs_observer.dart';
import 'chat_diary_app.dart';
import 'firebase_options.dart';
import 'models/category_cubit.dart';
import 'models/chat_cubit.dart';
import 'models/home_cubit.dart';
import 'models/new_chat_cubit.dart';
import 'models/theme_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = BlocsObserver();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final isSignedIn = await _anonymousAuth();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (_) => ThemeCubit(),
        ),
        BlocProvider<HomeCubit>(
          create: (_) => HomeCubit(),
        ),
        BlocProvider<MessageCubit>(
          create: (_) => MessageCubit(),
        ),
        BlocProvider<CategoryCubit>(
          create: (_) => CategoryCubit(),
        ),
        BlocProvider<NewChatCubit>(
          create: (_) => NewChatCubit(),
        ),
      ],
      child: isSignedIn
          ? const ChatDiaryApp()
          : const _ErrorAuthScreen(message: 'Authentication error.'),
    ),
  );
}

Future<bool> _anonymousAuth() async {
  try {
    final userCredential = await FirebaseAuth.instance.signInAnonymously();
    //await FirebaseAuth.instance.signOut();
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

class _ErrorAuthScreen extends StatelessWidget {
  final String message;

  const _ErrorAuthScreen({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.red,
        body: Center(
          child: Text(
            message,
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
