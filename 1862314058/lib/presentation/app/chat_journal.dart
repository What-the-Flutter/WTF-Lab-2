import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/chat_repository.dart';
import '../../theme/theme_constant.dart';
import '../home/home_state.dart';
import '../messages/messages_cubit.dart';
import 'app_page.dart';

class ChatJournal extends StatelessWidget {
  final User? user;
  const ChatJournal({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ///final chatRepository = ChatRepository();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeCubit(user: user),
        ),
        BlocProvider(
          create: (context) => MessagesCubit(user: user),
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
