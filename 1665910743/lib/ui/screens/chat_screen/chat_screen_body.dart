// ignore_for_file: prefer_relative_imports

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_journal/ui/screens/chat_screen/chat_list_body.dart';
import 'package:my_journal/ui/screens/chat_screen/icon_grid.dart';
import 'package:my_journal/ui/screens/chat_screen/tags_grid.dart';
import 'package:my_journal/ui/screens/settings/cubit/settings_cubit.dart';

import '../../../constants.dart' as constants;
import '../chat_screen/cubit/event_cubit.dart';
import 'chat_screen_nav_bar.dart';

class ChatScreenBody extends StatefulWidget {
  final EventCubit eventCubit;
  final String categoryTitle;

  const ChatScreenBody({
    Key? key,
    required this.categoryTitle,
    required this.eventCubit,
  }) : super(key: key);

  @override
  State<ChatScreenBody> createState() => _ChatScreenBodyState();
}

class _ChatScreenBodyState extends State<ChatScreenBody> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _renameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.text.length <= 1) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _renameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() => widget.eventCubit.iconAdd(false)),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        bloc: context.read<SettingsCubit>(),
        builder: (context, settingState) {
          return Container(
            decoration: (settingState.backgroundImagePath.length > 2)
                ? BoxDecoration(
                    image: DecorationImage(
                        image:
                            Image.file(File(settingState.backgroundImagePath))
                                .image,
                        fit: BoxFit.cover),
                  )
                : null,
            padding: constants.listViewPadding,
            child: BlocBuilder<EventCubit, EventState>(
              bloc: widget.eventCubit,
              builder: (context, state) => Column(
                children: [
                  ChatListBody(
                    categoryTitle: widget.categoryTitle,
                    eventCubit: widget.eventCubit,
                  ),
                  state.iconAdd
                      ? TagsGrid(eventCubit: widget.eventCubit)
                      : const SizedBox(),
                  state.iconAdd
                      ? IconsGrid(eventCubit: widget.eventCubit)
                      : const SizedBox(),
                  ChatScreenNavBar(
                    categoryTitle: widget.categoryTitle,
                    controller: _controller,
                    eventCubit: widget.eventCubit,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
