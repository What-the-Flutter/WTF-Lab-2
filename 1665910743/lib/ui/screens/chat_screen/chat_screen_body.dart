// ignore_for_file: prefer_relative_imports

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_journal/ui/screens/chat_screen/chat_list_body.dart';
import 'package:my_journal/ui/screens/chat_screen/icon_grid.dart';
import 'package:my_journal/ui/screens/chat_screen/tags_grid.dart';

import '../../../constants.dart';
import '../chat_screen/cubit/event_cubit.dart';
import '../settings/cubit/settings_cubit.dart';
import 'chat_screen_nav_bar.dart';

class ChatScreenBody extends StatefulWidget {
  final String categoryTitle;

  const ChatScreenBody({
    Key? key,
    required this.categoryTitle,
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
    final _backgroundImage =
        context.read<SettingsCubit>().state.backgroundImagePath;
    final _iconAdd = context.watch<EventCubit>().state.iconAdd;
    
    return GestureDetector(
      onTap: (() => context.read<EventCubit>().iconAdd(false)),
      child: Container(
        decoration: (_backgroundImage.length > 2)
            ? BoxDecoration(
                image: DecorationImage(
                    image: Image.file(File(_backgroundImage)).image,
                    fit: BoxFit.cover),
              )
            : null,
        padding: kListViewPadding,
        child: Column(
          children: [
            ChatListBody(categoryTitle: widget.categoryTitle),
            _iconAdd ? const TagsGrid() : const SizedBox(),
            _iconAdd ? const IconsGrid() : const SizedBox(),
            ChatScreenNavBar(
              categoryTitle: widget.categoryTitle,
              controller: _controller,
              eventCubit: context.read<EventCubit>(),
            ),
          ],
        ),
      ),
    );
  }
}
