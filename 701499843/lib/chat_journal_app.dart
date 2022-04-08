import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/firebase_provider.dart';
import 'data/repositories/chats_repository.dart';
import 'data/repositories/events_repository.dart';
import 'data/repositories/icons_repository.dart';
import 'pages/auth/auth_cubit.dart';
import 'pages/event_page/event_page_cubit.dart';
import 'pages/home/home.dart';
import 'pages/home/home_cubit.dart';
import 'pages/new_category_page/new_category_page_cubit.dart';
import 'pages/settings_page/settings_cubit.dart';
import 'pages/settings_page/settings_state.dart';
import 'themes/inherited_theme.dart';

class ChatJournalApp extends StatefulWidget {
  const ChatJournalApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChatJournalAppState();
}

class _ChatJournalAppState extends State<ChatJournalApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final db = FirebaseProvider();
    return AppThemeProvider(
      child: Builder(
        builder: (context) => MultiRepositoryProvider(
          providers: [
            RepositoryProvider<EventsRepository>(
              create: (_) => EventsRepository(db),
            ),
            RepositoryProvider<ChatsRepository>(
              create: (_) => ChatsRepository(db),
            ),
            RepositoryProvider<IconsRepository>(
              create: (_) => IconsRepository(db),
            ),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => HomeCubit(
                  context.read<ChatsRepository>(),
                  context.read<EventsRepository>(),
                  context.read<IconsRepository>(),
                ),
              ),
              BlocProvider(
                create: (context) => NewCategoryPageCubit(
                  context.read<IconsRepository>(),
                ),
              ),
              BlocProvider(
                create: (context) => EventPageCubit(
                  context.read<EventsRepository>(),
                  context.read<ChatsRepository>(),
                ),
              ),
              BlocProvider(
                create: (_) => SettingsCubit(),
              ),
              BlocProvider(
                create: (_) => AuthCubit(),
              ),
            ],
            child: BlocBuilder<SettingsCubit, SettingsState>(
              builder: ((context, state) {
                context.read<AuthCubit>().authorize();

                return MaterialApp(
                  title: 'WTF Project',
                  theme: state.currentTheme,
                  home: const HomePage(
                    title: 'Home',
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
