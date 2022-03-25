import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/categorylist_cubit.dart';
import '../widgets/chat_screen_body.dart';
import '../widgets/home_widget.dart';

class ChatScreen extends StatefulWidget {
  final int eventId;

  const ChatScreen({
    Key? key,
    required this.eventId,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context
              .read<CategorylistCubit>()
              .state
              .categoryList[widget.eventId]
              .title,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(
              () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Home(),
                  ),
                );
              },
            );
          },
        ),
      ),
      body: ChatScreenBody(
        eventId: widget.eventId,
      ),
    );
  }
}
