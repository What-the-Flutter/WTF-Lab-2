import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../theme/theme_cubit/theme_cubit.dart';
import '../Chat_Screen/chat_screen_body.dart';
import '../home/cubit/home_cubit.dart';
import '../home/home_widget.dart';
import 'cubit/event_cubit.dart';

class ChatScreen extends StatelessWidget {
  final EventCubit eventCubit;
  final String categoryTitle;

  const ChatScreen({
    Key? key,
    required this.categoryTitle,
    required this.eventCubit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          categoryTitle,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            eventCubit.stopAnimate();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Home(
                  homeCubit: context.read<HomeCubit>(),
                  themeCubit: context.read<ThemeCubit>(),
                ),
              ),
            );
          },
        ),
      ),
      body: ChatScreenBody(
        categoryTitle: categoryTitle,
        eventCubit: eventCubit,
      ),
    );
  }
}
