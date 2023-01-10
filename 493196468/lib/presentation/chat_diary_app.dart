import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repo/firebase/chats_repository.dart';
import '../repo/firebase/firebase_implementation.dart';
import '../repo/firebase/messages_repository.dart';
import 'main_page.dart';
import 'pages/chat_page/cubit/category_cubit.dart';
import 'pages/chat_page/cubit/chat_cubit.dart';
import 'pages/home_page/cubit/home_cubit.dart';
import 'pages/home_page/home_view.dart';
import 'pages/new_chat_page/cubit/new_chat_cubit.dart';
import 'settings/cubit/settings_cubit/settings_cubit.dart';
import 'settings/theme.dart';

class ChatDiaryApp extends StatefulWidget {
  final bool isSignedIn;

  const ChatDiaryApp({Key? key, required this.isSignedIn}) : super(key: key);

  @override
  State<ChatDiaryApp> createState() => _ChatDiaryAppState();
}

class _ChatDiaryAppState extends State<ChatDiaryApp> {
  late final MessagesRepository messagesRepository;
  late final ChatsRepository chatsRepository;

  @override
  void initState() {
    super.initState();
    final firebaseRepository = FirebaseRepository();
    chatsRepository = ChatsRepository(firebaseRepository);
    messagesRepository = MessagesRepository(firebaseRepository);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SettingsCubit>(
          create: (_) => SettingsCubit(),
        ),
        BlocProvider<HomeCubit>(
          create: (_) => HomeCubit(chatsRepository),
        ),
        BlocProvider<MessageCubit>(
          create: (_) => MessageCubit(messagesRepository),
        ),
        BlocProvider<CategoryCubit>(
          create: (_) => CategoryCubit(),
        ),
        BlocProvider<NewChatCubit>(
          create: (_) => NewChatCubit(),
        ),
      ],
      child: widget.isSignedIn
          ? const MainView()
          : const _ErrorAuthScreen(message: 'Authentication error.'),
    );
  }
}

class MainView extends StatelessWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: state.themeMode,
          theme: lightTheme,
          darkTheme: darkTheme,
          home: MainPage(),
        );
      },
    );
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
