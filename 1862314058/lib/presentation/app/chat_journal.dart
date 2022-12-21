import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/anonymous_auth.dart';
import '../../theme/theme_constant.dart';
import '../home/home_state.dart';
import '../messages/messages_cubit.dart';
import 'app_page.dart';

class ChatJournal extends StatelessWidget {
  const ChatJournal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginUser = AuthService().signInAnonymous();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeCubit(user: AuthService().currentUser!),
        ),
        BlocProvider(
          create: (context) => MessagesCubit(user: AuthService().currentUser!),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppThemes.lightTheme,
        darkTheme: AppThemes.darkTheme,
        home: const AppPage(title: 'Home'),
      ),
    );
  }
}
