import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ui/components/user_auth.dart';
import 'ui/screens/home/home_screen.dart';
import 'ui/themes/theme_controller_cubit.dart';
import 'ui/themes/theme_provider.dart';

class ChatJournalApp extends StatelessWidget {
  final String _appTitle = 'Chat Journal';

  const ChatJournalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return UserAuthentication(
      child: ThemeProvider(
        child: BlocBuilder<ThemeControllerCubit, ThemeControllerState>(
          buildWhen: (previous, current) {
            return previous.appState.isLightTheme !=
                current.appState.isLightTheme;
          },
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: _appTitle,
              theme: context.read<ThemeControllerCubit>().fetchTheme(),
              home: const HomeScreen(),
            );
          },
        ),
      ),
    );
  }
}
