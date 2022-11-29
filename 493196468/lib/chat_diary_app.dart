import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'models/chat_cubit.dart';
import 'models/home_cubit.dart';
import 'models/theme_cubit.dart';
import 'pages/home_view.dart';
import 'themes/theme.dart';

class ChatDiaryApp extends StatefulWidget {
  const ChatDiaryApp({Key? key}) : super(key: key);

  @override
  State<ChatDiaryApp> createState() => _ChatDiaryAppState();
}

class _ChatDiaryAppState extends State<ChatDiaryApp> {
  @override
  void initState() {
    context.read<ThemeCubit>().init();
    context.read<HomeCubit>()
      ..init()
      ..checkForUpdates();
    context.read<MessageCubit>()
      ..init()
      ..checkForUpdates();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: context.read<ThemeCubit>().state.themeMode,
          theme: lightTheme,
          darkTheme: darkTheme,
          home: const HomeView(),
        );
      },
    );
  }
}
