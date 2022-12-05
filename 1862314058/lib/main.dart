import 'package:chat_app/presentation/home/home_state.dart';
import 'package:chat_app/presentation/messages/messages_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'presentation/app/chat_journal.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeCubit(),
        ),
        BlocProvider(
          create: (context) => MessagesCubit(),
        ),
      ],
      child: const ChatJournal(),
    ),
  );
}
