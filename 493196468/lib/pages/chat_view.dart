import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/category_cubit.dart';
import '../models/chat_cubit.dart';
import '../models/home_cubit.dart';
import '../models/theme_cubit.dart';
import '../utils/chat_card.dart';
import '../utils/message.dart';

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
    return BlocBuilder<MessageCubit, MessagesState>(
      builder: (context, state) {
        final messages = state.messages
            .where((element) => element.chatId == chatCard.id)
            .toList();
        return Scaffold(
          appBar: _getAppBar(
            context,
            state,
            chatId,
          ),
          body: Container(
            color: _getColor(
              theme,
              state.filter.isFiltered,
            ),
            child: SafeArea(
              child: Column(
                children: [
                  _MessagesBuilder(
                    chatId: chatId,
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

  Color? _getColor(ThemeData theme, bool isFiltered) {
    if (!isFiltered) {
      return theme.brightness == Brightness.light
          ? theme.primaryColorLight
          : theme.primaryColorDark;
    }
    return null;
  }

  AppBar _getAppBar(BuildContext context, MessagesState state, String chatId) {
    final isSelectedList =
        state.messages.where((element) => element.isSelected);
    final selectedAmount = isSelectedList.length;
    return state.filter.isFiltered
        ? _filterAppBar(context, chatId, selectedAmount)
        : _commonAppBar(context, chatId, selectedAmount);
  }

  AppBar _commonAppBar(
      BuildContext context, String chatId, int selectedAmount) {
    return AppBar(
      leading: selectedAmount >= 1 ? _cancelSelectedButton(context) : null,
      actions: [
        _AppBarButtonsBuilder(
          isFiltered: true,
          chatId: chatId,
          selectedAmount: selectedAmount,
        ),
      ],
      title: selectedAmount == 0 ? Text(chatCard.title) : null,
    );
  }

  IconButton _cancelSelectedButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.cancel_outlined),
      onPressed: () => context.read<MessageCubit>().unselectAllMessages(),
    );
  }

  AppBar _filterAppBar(
      BuildContext context, String chatId, int selectedAmount) {
    return AppBar(
      leading: _filterBackButton(context, chatId),
      title: selectedAmount == 0
          ? _AppBarTextField(chatId: chatId)
          : const SizedBox(),
      actions: [
        _AppBarButtonsBuilder(
          selectedAmount: selectedAmount,
          chatId: chatId,
        ),
      ],
    );
  }

  IconButton _filterBackButton(BuildContext context, String chatId) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios),
      onPressed: () {
        context.read<MessageCubit>()
          ..deleteFilter()
          ..filterMessages('', chatId);
      },
    );
  }
}

class _MessageTile extends StatelessWidget {
  final Message message;

  const _MessageTile({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 5,
        ),
        message.isSelected
            ? const Icon(
                Icons.check,
                size: 18,
              )
            : const SizedBox(),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          margin: const EdgeInsets.all(8),
          constraints: const BoxConstraints(maxWidth: 300),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      message.text,
                      style: const TextStyle(fontSize: 16),
                      overflow: TextOverflow.clip,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    '${message.sentTime.hour} : ${message.sentTime.minute}',
                    style: const TextStyle(fontSize: 9),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                ],
              ),
              message.pictureURL != null ? _pictureView() : const SizedBox(),
            ],
          ),
        ),
      ],
    );
  }

  Container _pictureView() {
    return Container(
      constraints: const BoxConstraints(
        maxHeight: 300,
        maxWidth: 300,
      ),
      child: Image(
        image: NetworkImage(message.pictureURL!),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColorDark,
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      ),
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
        context.read<MessageCubit>().addMessage(
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
            child: TextField(
              onSubmitted: (text) {
                context.read<MessageCubit>().addMessage(
                      Message(
                        text: text,
                        chatId: widget.chatId,
                      ),
                    );
                _controller.clear();
                context.read<CategoryCubit>().closeCategories();
              },
              controller: _controller,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Write your event',
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

class _MessagesBuilder extends StatelessWidget {
  final String chatId;
  final List<Message> messages;

  const _MessagesBuilder({
    Key? key,
    required this.chatId,
    required this.messages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        color: theme.brightness == Brightness.light
            ? theme.primaryColor
            : theme.primaryColorDark,
        child: ListView.builder(
          cacheExtent: 100,
          reverse: true,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onLongPress: () {
                context.read<MessageCubit>().selectMessage(
                      messages.reversed.elementAt(index),
                    );
              },
              child: _DismissibleMessage(
                message: messages[index],
                onDismissed: (direction) {
                  switch (direction) {
                    case DismissDirection.startToEnd:
                      context.read<MessageCubit>().startEditMessage(
                            messages.reversed.elementAt(index),
                          );
                      break;
                    case DismissDirection.endToStart:
                      context.read<MessageCubit>().deleteMessage(
                            messages.reversed.elementAt(index),
                          );
                      break;
                    default:
                      break;
                  }
                },
                child: _MessageTile(
                  message: messages.reversed.elementAt(index),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AppBarButtonsBuilder extends StatelessWidget {
  final String chatId;
  final int selectedAmount;
  final bool isFiltered;

  const _AppBarButtonsBuilder({
    Key? key,
    required this.selectedAmount,
    required this.chatId,
    this.isFiltered = false,
  }) : super(key: key);

  List<IconButton> _getAppBarButtons(BuildContext context, int selectedAmount) {
    final appBarButtonList = <IconButton>[];
    if (selectedAmount == 0 && isFiltered) {
      appBarButtonList.add(
        IconButton(
          onPressed: () => context.read<MessageCubit>().setFilter(''),
          icon: const Icon(Icons.search),
        ),
      );
      appBarButtonList.add(
        IconButton(
          onPressed: () => context.read<ThemeCubit>().changeTheme(),
          icon: const Icon(Icons.emoji_objects_outlined),
        ),
      );
    }
    if (selectedAmount >= 1) {
      appBarButtonList.add(
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (c) => _ShearingDialog(
                messageContext: context,
                chatId: chatId,
              ),
            );
          },
          icon: const Icon(Icons.reply),
        ),
      );
      appBarButtonList.add(
        IconButton(
          onPressed: () =>
              context.read<MessageCubit>().deleteSelectedMessages(),
          icon: const Icon(Icons.delete),
        ),
      );
    }
    if (selectedAmount == 1) {
      if (isFiltered) {
        appBarButtonList.add(
          IconButton(
            onPressed: () =>
                context.read<MessageCubit>().startEditSelectedMessage(),
            icon: const Icon(Icons.edit),
          ),
        );
      }
      appBarButtonList.add(
        IconButton(
          onPressed: () => context.read<MessageCubit>().copyMessage(),
          icon: const Icon(Icons.copy),
        ),
      );
    }
    return appBarButtonList;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _getAppBarButtons(
        context,
        selectedAmount,
      ),
    );
  }
}

class _AppBarTextField extends StatefulWidget {
  final String chatId;

  const _AppBarTextField({
    Key? key,
    required this.chatId,
  }) : super(key: key);

  @override
  State<_AppBarTextField> createState() => _AppBarTextFieldState();
}

class _AppBarTextFieldState extends State<_AppBarTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    _controller.text = context.read<MessageCubit>().state.filter.filterStr;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: (filter) {
        context.read<MessageCubit>()
          ..filterMessages(filter, widget.chatId)
          ..setFilter(filter);
      },
    );
  }
}

class _ShearingDialog extends StatefulWidget {
  final BuildContext messageContext;
  final String chatId;

  const _ShearingDialog({
    Key? key,
    required this.messageContext,
    required this.chatId,
  }) : super(key: key);

  @override
  State<_ShearingDialog> createState() => _ShearingDialogState();
}

class _ShearingDialogState extends State<_ShearingDialog> {
  String _radioValue = '-1';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).primaryColorLight,
      title: const Text(
        'Select the page you want to migrate the selected event(S) to!',
      ),
      content: SizedBox(
        width: 300,
        height: 200,
        child: BlocBuilder<HomeCubit, ChatsState>(
          builder: (context, state) {
            return ListView.builder(
              itemCount: state.chatCards.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Radio(
                      value: state.chatCards[index].id,
                      groupValue: _radioValue,
                      onChanged: (value) =>
                          setState(() => _radioValue = value!),
                    ),
                    Text(state.chatCards[index].title),
                  ],
                );
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            widget.messageContext
                .read<MessageCubit>()
                .migrateMessages(_radioValue, widget.chatId);
            Navigator.pop(context);
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}

class _DismissibleMessage extends StatelessWidget {
  final Message message;
  final Widget child;
  final DismissDirectionCallback onDismissed;

  _DismissibleMessage({
    Key? key,
    required this.message,
    required this.child,
    required this.onDismissed,
  }) : super(key: UniqueKey());

  @override
  Widget build(BuildContext context) => Dismissible(
        key: ObjectKey(message),
        background: _swipeActionLeft(),
        secondaryBackground: _swipeActionRight(),
        onDismissed: onDismissed,
        child: child,
      );

  Widget _swipeActionLeft() => Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(
          Icons.edit,
          size: 32,
        ),
      );

  Widget _swipeActionRight() => Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(
          Icons.delete_forever,
          size: 32,
        ),
      );
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
                      await context.read<MessageCubit>().pickImage().then(
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
              {
                return _categoryButtons(index - 2, state);
              }
          }
        },
      ),
    );
  }

  Container _categoryButtons(int index, CategoryState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32),
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
          Text(text),
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
      title: const Text(
        'Please go to settings and grant photo permission to this app.',
      ),
      content: const SizedBox(
        width: 250,
        height: 50,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            openAppSettings();
            Navigator.pop(context);
          },
          child: const Text('Settings'),
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
        context.read<MessageCubit>().state.picturePath?.picturePath ?? '';
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
            onTap: () => context.read<MessageCubit>().removePicture(),
            child: const Icon(
              Icons.cancel,
            ),
          ),
        ),
      ],
    );
  }
}
