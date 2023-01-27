import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../theme/theme_state.dart';
import '../home/home_state.dart';
import '../messages/messages_cubit.dart';
import '../settings/settings_state.dart';
import 'app_page.dart';

class ChatJournal extends StatelessWidget {
  final User? curUser;

  const ChatJournal({
    super.key,
    this.curUser,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeCubit(
            user: curUser,
          ),
        ),
        BlocProvider(
          create: (context) => MessagesCubit(
            user: curUser,
          ),
        ),
        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider(
          create: (context) => SettingsCubit(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: state.appThemes,
            home: const AppPage(
              title: 'Home',
            ),
          );
        },
      ),
    );
  }
}
