import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/category_list_cubit.dart';
import '../widgets/chat_screen_body.dart';
import '../widgets/home_widget.dart';

class ChatScreen extends StatelessWidget {
  final int eventId;

  const ChatScreen({
    Key? key,
    required this.eventId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.read<CategoryListCubit>().state.categoryList[eventId].title,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Home(),
            ),
          ),
        ),
      ),
      body: ChatScreenBody(
        eventId: eventId,
      ),
    );
  }
}
