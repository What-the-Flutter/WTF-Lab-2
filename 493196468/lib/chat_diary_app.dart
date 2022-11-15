import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'models/chat_cubit.dart';
import 'models/filter_cubit.dart';
import 'models/home_cubit.dart';
import 'models/new_chat_cubit.dart';
import 'pages/home_view.dart';
import 'repo/chats/chats_repository.dart';
import 'repo/messages/messages_repository.dart';
import 'themes/theme_changer.dart';

class ChatDiaryApp extends StatelessWidget {
  const ChatDiaryApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatsRepository = ChatsRepository();
    final messagesRepository = MessagesRepository();
    return FutureBuilder(
      future: chatsRepository.getAllChats(),
      builder: (context, snapshot) {
        return snapshot.connectionState == ConnectionState.done
            ? MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => FilterCubit(),
                  ),
                  BlocProvider<HomeCubit>(
                    create: (context) => HomeCubit(
                      chatsRepository,
                      snapshot.data ?? [],
                    ),
                  ),
                  BlocProvider<MessageCubit>(
                    create: (context) => MessageCubit(
                      messagesRepository,
                      BlocProvider.of<FilterCubit>(context),
                    ),
                  ),
                  BlocProvider(
                    create: (context) => NewChatCubit(),
                  ),
                ],
                child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: ThemeChanger.of(context).theme,
                  home: const HomeView(),
                ),
              )
            : const SafeArea(
                child: CircularProgressIndicator(),
              );
      },
    );
  }
}
