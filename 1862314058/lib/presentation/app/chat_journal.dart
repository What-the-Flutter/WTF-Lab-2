import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/firebase_auth_repository.dart';
import '../../theme/theme_state.dart';
import '../auth/auth_cubit.dart';
import '../auth/auth_state.dart';
import '../home/home_state.dart';
import '../messages/messages_cubit.dart';
import '../settings/settings_state.dart';
import '../statistics/statistics_state.dart';
import 'app_page.dart';

class ChatJournal extends StatelessWidget {
  final FirebaseAuthRepository firebaseAuthRepository =
      FirebaseAuthRepository(FirebaseAuth.instance);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeCubit(
            // user: firebaseAuthRepository,
          ),
        ),
        BlocProvider(
          create: (context) => MessagesCubit(
            // user: firebaseAuthRepository,
          ),
        ),
        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider(
          create: (context) => SettingsCubit(),
        ),
        BlocProvider(
          create: (context) => AuthCubit(firebaseAuthRepository)..checkAuth(),
        ),
        BlocProvider(
          create: (context) => StatisticsCubit(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state.authStatus == AuthStatus.unauth) {
                context.read<AuthCubit>().signAnon();
              } else if (state.authStatus == AuthStatus.auth) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AppPage(title: 'home'),
                  ),
                );
              } else {
                const Text('Error auth');
              }
            },
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: state.appThemes,
              home: const AppPage(
                title: 'Home',
              ),
            ),
          );
        },
      ),
    );
  }
}
