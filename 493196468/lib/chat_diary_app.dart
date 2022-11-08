import 'package:flutter/material.dart';
import 'package:diary/repo/chats/chat_list_preferences.dart';
import 'package:diary/themes/theme_changer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home/cubit/home_cubit.dart';
import 'home/view/home_view.dart';



class ChatDiaryApp extends StatelessWidget {
  const ChatDiaryApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (BuildContext context) => HomeCubit(ChatListPreferences.getChatCards()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeChanger.of(context).theme,
        home: const HomeView(),
        //home: const ChatPage(chatTitle: 'Travel'),
      ),
    );
  }
}