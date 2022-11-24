import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../theme/theme_constant.dart';
import '../home/home_state.dart';
import '../messages/messages_cubit.dart';
import 'app_page.dart';

class ChatJournal extends StatelessWidget {
  const ChatJournal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => HomeCubit()),
          BlocProvider(create: (context) => MessagesCubit()),
        ],
        child: const AppPage(title: 'Home'),
      ),
    );
  }
}
