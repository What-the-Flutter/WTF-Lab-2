import 'package:flutter/material.dart';


import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repo/messages/message_list_preferences.dart';
import '../cubit/chat_cubit.dart';
import 'chat_view.dart';
import 'filter_changer.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({
    Key? key,
    required this.chatTitle,
  }) : super(key: key);

  final String chatTitle;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MessageCubit>(
      create: (_) =>
          MessageCubit(MessageListPreferences.getMessages(chatTitle)),
      child: FilterStateChanger(
        child: ChatView(
          chatTitle: chatTitle,
        ),
      ),
    );
  }
}
