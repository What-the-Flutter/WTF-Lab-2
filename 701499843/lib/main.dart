import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/repositories/chats_repository.dart';
import 'data/repositories/events_repository.dart';
import 'data/repositories/icons_repository.dart';
import 'firebase_options.dart';
import 'pages/event_page/event_page_cubit.dart';
import 'pages/home/home.dart';
import 'pages/home/home_cubit.dart';
import 'pages/new_category_page/new_category_page_cubit.dart';
import 'pages/settings_page/settings_cubit.dart';
import 'pages/settings_page/settings_state.dart';
import 'themes/inherited_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var userCredential = await FirebaseAuth.instance.signInAnonymously();
  print(userCredential.user);
  runApp(const ChatJournalApp());
}

class ChatJournalApp extends StatelessWidget {
  const ChatJournalApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppThemeProvider(
      child: Builder(
        builder: (context) => MultiRepositoryProvider(
          providers: [
            RepositoryProvider<EventsRepository>(
              create: (context) => EventsRepository(),
            ),
            RepositoryProvider<ChatsRepository>(
              create: (context) => ChatsRepository(),
            ),
            RepositoryProvider<IconsRepository>(
              create: (context) => IconsRepository(),
            ),
          ],
          child: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => HomeCubit(
                    context.read<ChatsRepository>(),
                    context.read<EventsRepository>(),
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
                  create: (context) => SettingsCubit(),
                ),
              ],
              child: BlocBuilder<SettingsCubit, SettingsState>(
                  builder: ((context, state) {
                return MaterialApp(
                  title: 'WTF Project',
                  theme: state.currentTheme,
                  home: const HomePage(
                    title: 'Home',
                  ),
                );
              }))),
        ),
      ),
    );
  }
}
