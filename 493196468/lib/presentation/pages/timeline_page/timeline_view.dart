import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/main_pages_widgets/main_app_bar.dart';
import '../../widgets/main_pages_widgets/messages_list.dart';
import '../chat_page/cubit/chat_cubit.dart';

class TimelineView extends StatelessWidget {
  const TimelineView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        final messages =
        context.read<ChatCubit>().getAllMessages();
        return Scaffold(
          appBar: getAppBar(
            context: context,
            state: state,
            title: 'Timeline',
          ),
          body: Container(
            color: theme.brightness == Brightness.light
                ? theme.primaryColorLight
                : theme.primaryColorDark,
            child: SafeArea(
              child: Column(
                children: [
                  BodyWithMessages(
                    messages: messages,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
