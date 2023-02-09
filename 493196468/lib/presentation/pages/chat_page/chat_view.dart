import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashtagable/hashtagable.dart';
import 'package:permission_handler/permission_handler.dart';

import '/utils/chat_card.dart';
import '/utils/message.dart';
import '../../settings/cubit/settings_cubit/settings_cubit.dart';
import '../../settings/theme.dart';
import '../../widgets/main_pages_widgets/main_app_bar.dart';
import '../../widgets/main_pages_widgets/messages_list.dart';
import 'cubit/category_cubit.dart';
import 'cubit/chat_cubit.dart';

class ChatView extends StatelessWidget {
  final ChatCard chatCard;

  const ChatView({
    super.key,
    required this.chatCard,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chatId = chatCard.id ?? '-1';
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        final messages =
            context.read<ChatCubit>().getMessagesFromChat(chatId);
        return Scaffold(
          appBar: getAppBar(
            context: context,
            state: state,
            title: chatCard.title,
            chatId: chatId,
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
                  const _CategoryView(),
                  _SelectedPictureView(),
                  state.filter.isFiltered
                      ? const SizedBox()
                      : _TextField(
                          key: UniqueKey(),
                          messages: messages,
                          chatId: chatId,
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

class _CategoryChoiceButton extends StatelessWidget {
  const _CategoryChoiceButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => context.read<CategoryCubit>().showCategories(),
      icon: const Icon(Icons.category),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final TextEditingController controller;
  final String chatId;
  final bool onEdit;

  const _SubmitButton({
    Key? key,
    required this.controller,
    required this.chatId,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        context.read<ChatCubit>().addMessage(
              Message(
                text: controller.text,
                chatId: chatId,
              ),
            );
        controller.clear();
        context.read<CategoryCubit>().closeCategories();
      },
      icon: const Icon(Icons.arrow_forward),
    );
  }
}

class _TextField extends StatefulWidget {
  final List<Message> messages;
  final String chatId;

  const _TextField({
    Key? key,
    required this.chatId,
    required this.messages,
  }) : super(key: key);

  @override
  State<_TextField> createState() => _TextFieldState();
}

class _TextFieldState extends State<_TextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final editableMessageIndex =
        widget.messages.indexWhere((element) => element.onEdit);
    _controller = editableMessageIndex != -1
        ? TextEditingController(
            text: widget.messages[editableMessageIndex].text,
          )
        : TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editableMessageIndex =
        widget.messages.indexWhere((element) => element.onEdit);
    final onEdit = editableMessageIndex != -1 ? true : false;
    final theme = Theme.of(context);
    return Container(
      color: theme.brightness == Brightness.light
          ? theme.primaryColorLight
          : theme.primaryColorDark,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const _CategoryChoiceButton(),
          Expanded(
            child: HashTagTextField(
              basicStyle: getTitleText(
                context.read<SettingsCubit>().state.textSize,
                context,
              ),
              decoratedStyle: getTitleText(
                context.read<SettingsCubit>().state.textSize,
                context,
              ).copyWith(color: Colors.blue),
              onSubmitted: (text) {
                context.read<ChatCubit>().addMessage(
                      Message(
                        text: text,
                        chatId: widget.chatId,
                      ),
                    );
                _controller.clear();
                context.read<CategoryCubit>().closeCategories();
              },
              controller: _controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Write your event',
                hintStyle: getTitleText(
                  context.read<SettingsCubit>().state.textSize,
                  context,
                ),
              ),
            ),
          ),
          _SubmitButton(
            controller: _controller,
            chatId: widget.chatId,
            onEdit: onEdit,
          ),
        ],
      ),
    );
  }
}



class _CategoryView extends StatelessWidget {
  const _CategoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        final color = Theme.of(context).primaryColorLight;
        return state.isUnderChoice
            ? _categoryRow(color, state)
            : const SizedBox();
      },
    );
  }

  Container _categoryRow(Color color, CategoryState state) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        border: Border(
          bottom: BorderSide(
            color: color,
          ),
        ),
      ),
      constraints: const BoxConstraints(maxHeight: 70),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: state.categories.length + 2,
        itemBuilder: (context, index) {
          switch (index) {
            case 0:
              {
                return _serviceCategoryButton(
                  context: context,
                  icon: const Icon(Icons.cancel_outlined),
                  onPressed: (context) =>
                      context.read<CategoryCubit>().closeCategories(),
                  text: 'Cancel',
                );
              }
            case 1:
              {
                return _serviceCategoryButton(
                  context: context,
                  icon: const Icon(Icons.image_outlined),
                  onPressed: (context) async =>
                      await context.read<ChatCubit>().pickImage().then(
                    (value) {
                      if (value == false) {
                        showDialog(
                          context: context,
                          builder: (_) => const _PhotoPermissionDialog(),
                        );
                      } else {
                        context.read<CategoryCubit>().closeCategories();
                      }
                    },
                  ),
                  text: 'Image',
                );
              }
            default:
                return _categoryButtons(index - 2, state);
          }
        },
      ),
    );
  }

  Container _categoryButtons(int index, CategoryState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              print(index.toString());
            },
            icon: Icon(
              state.categories[index].icon.icon,
            ),
          ),
          Text(state.categories[index].title),
        ],
      ),
    );
  }

  Container _serviceCategoryButton({
    required context,
    required Icon icon,
    required void Function(BuildContext context) onPressed,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColorDark,
            ),
            child: IconButton(
              color: Theme.of(context).brightness == Brightness.light
                  ? Theme.of(context).primaryColorLight
                  : Theme.of(context).primaryColor,
              onPressed: () => onPressed(context),
              icon: icon,
            ),
          ),
          Text(
            text,
            style: getBodyText(TextSizeKeys.medium, context),
          ),
        ],
      ),
    );
  }
}

class _PhotoPermissionDialog extends StatelessWidget {
  const _PhotoPermissionDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).primaryColorLight,
      title: Text(
        'Please go to settings and grant photo permission to this app.',
        style: getTitleText(
          context.read<SettingsCubit>().state.textSize,
          context,
        ),
      ),
      content: const SizedBox(
        width: 250,
        height: 50,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: getTitleText(
              context.read<SettingsCubit>().state.textSize,
              context,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            openAppSettings();
            Navigator.pop(context);
          },
          child: Text(
            'Settings',
            style: getTitleText(
              context.read<SettingsCubit>().state.textSize,
              context,
            ),
          ),
        ),
      ],
    );
  }
}

class _SelectedPictureView extends StatelessWidget {
  _SelectedPictureView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final picturePath =
        context.read<ChatCubit>().state.picturePath?.picturePath ?? '';
    return Container(
      constraints: const BoxConstraints(maxHeight: 100),
      child: picturePath.isNotEmpty
          ? _selectedPictureView(picturePath, context)
          : const SizedBox(),
    );
  }

  Stack _selectedPictureView(String picturePath, BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
            padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
            child: Image.file(File(picturePath))),
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: () => context.read<ChatCubit>().removePicture(),
            child: const Icon(
              Icons.cancel,
            ),
          ),
        ),
      ],
    );
  }
}
