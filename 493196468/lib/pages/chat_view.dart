import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/chat_cubit.dart';
import '../models/filter_cubit.dart';
import '../models/home_cubit.dart';
import '../themes/theme_changer.dart';
import '../utils/chat_card.dart';
import '../utils/message.dart';

class ChatView extends StatelessWidget {
  final ChatCard chatCard;

  const ChatView({
    super.key,
    required this.chatCard,
  });

  Color? _getColor(ThemeData theme, bool isFiltered) {
    if (!isFiltered) {
      return theme.brightness == Brightness.light
          ? theme.primaryColorLight
          : theme.primaryColorDark;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeChanger.of(context).theme;
    final chatId = chatCard.id!;
    context.read<MessageCubit>().emitMessagesFromChat(chatId);
    return BlocBuilder<FilterCubit, Filter>(
      builder: (context, filterState) {
        return BlocBuilder<MessageCubit, List<Message>>(
          builder: (context, state) {
            return Scaffold(
              appBar: _getAppBar(
                context,
                state,
                chatId,
              ),
              body: Container(
                color: _getColor(
                  theme,
                  filterState.isFiltered,
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      _MessagesBuilder(chatId: chatId),
                      context.read<FilterCubit>().isFiltered()
                          ? const SizedBox()
                          : _TextField(
                              key: UniqueKey(),
                              messages: state,
                              chatId: chatId,
                            ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  AppBar _getAppBar(BuildContext context, List<Message> state, int chatId) {
    final isSelectedList = state.where((element) => element.isSelected);
    final selectedAmount = isSelectedList.length;
    return context.read<FilterCubit>().isFiltered()
        ? AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                context.read<FilterCubit>().deleteFilter();
                context.read<MessageCubit>().filterMessages('', chatId);
              },
            ),
            title: selectedAmount == 0
                ? AppBarTextField(
                    chatId: chatId,
                  )
                : const SizedBox(),
            actions: [
              _AppBarButtonsBuilder(
                selectedAmount: selectedAmount,
                chatId: chatId,
              ),
            ],
          )
        : AppBar(
            leading: selectedAmount >= 1
                ? IconButton(
                    icon: const Icon(Icons.cancel_outlined),
                    onPressed: () =>
                        context.read<MessageCubit>().unselectAllMessages(),
                  )
                : null,
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
          child: Row(
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
        ),
      ],
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final TextEditingController controller;
  final int chatId;
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
      },
      icon: const Icon(Icons.arrow_forward),
    );
  }
}

class _TextField extends StatefulWidget {
  final List<Message> messages;
  final int chatId;

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
    final theme = ThemeChanger.of(context).theme;
    return Container(
      color: theme.brightness == Brightness.light
          ? theme.primaryColorLight
          : theme.primaryColorDark,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(
            width: 16,
          ),
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
  final int chatId;

  const _MessagesBuilder({
    Key? key,
    required this.chatId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        color: theme.brightness == Brightness.light
            ? theme.primaryColor
            : theme.primaryColorDark,
        child: BlocBuilder<MessageCubit, List<Message>>(
          builder: (context, state) {
            return ListView.builder(
              reverse: true,
              itemCount: state.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onLongPress: () {
                    context.read<MessageCubit>().selectMessage(
                          state.reversed.elementAt(index),
                        );
                  },
                  child: DismissibleMessage(
                    message: state[index],
                    onDismissed: (direction) {
                      switch (direction) {
                        case DismissDirection.startToEnd:
                          context.read<MessageCubit>().startEditMessage(
                                state.reversed.elementAt(index),
                              );
                          break;
                        case DismissDirection.endToStart:
                          context.read<MessageCubit>().deleteMessage(
                                state.reversed.elementAt(index),
                              );
                          break;
                        default:
                          break;
                      }
                    },
                    child: _MessageTile(
                      message: state.reversed.elementAt(index),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _AppBarButtonsBuilder extends StatelessWidget {
  final int chatId;
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
          onPressed: () => context.read<FilterCubit>().setFilter(''),
          icon: const Icon(Icons.search),
        ),
      );
      appBarButtonList.add(
        IconButton(
          onPressed: () {
            ThemeChanger.of(context).stateWidget.changeTheme();
          },
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
              builder: (c) => ShearingDialog(
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

class AppBarTextField extends StatefulWidget {
  final int chatId;

  const AppBarTextField({
    Key? key,
    required this.chatId,
  }) : super(key: key);

  @override
  State<AppBarTextField> createState() => _AppBarTextFieldState();
}

class _AppBarTextFieldState extends State<AppBarTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    _controller.text = context.read<FilterCubit>().state.filter;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: (filter) {
        context.read<MessageCubit>().filterMessages(filter, widget.chatId);
        context.read<FilterCubit>().setFilter(filter);
      },
    );
  }
}

class ShearingDialog extends StatefulWidget {
  final BuildContext messageContext;
  final int chatId;

  const ShearingDialog({
    Key? key,
    required this.messageContext,
    required this.chatId,
  }) : super(key: key);

  @override
  State<ShearingDialog> createState() => _ShearingDialogState();
}

class _ShearingDialogState extends State<ShearingDialog> {
  int _radioValue = -1;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).primaryColorLight,
      title: const Text(
        'Select the page you want to migrate the selected event(S) to!',
      ),
      content: SizedBox(
        width: 300,
        height: 300,
        child: BlocBuilder<HomeCubit, List<ChatCard>>(
          builder: (context, state) {
            return ListView.builder(
              itemCount: state.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Radio(
                      value: state[index].id,
                      groupValue: _radioValue,
                      onChanged: (value) =>
                          setState(() => _radioValue = value!),
                    ),
                    Text(state[index].title),
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

class DismissibleMessage extends StatelessWidget {
  final Message message;
  final Widget child;
  final DismissDirectionCallback onDismissed;

  const DismissibleMessage({
    Key? key,
    required this.message,
    required this.child,
    required this.onDismissed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Dismissible(
        key: ObjectKey(message),
        background: buildSwipeActionLeft(),
        secondaryBackground: buildSwipeActionRight(),
        onDismissed: onDismissed,
        child: child,
      );

  Widget buildSwipeActionLeft() => Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(
          Icons.edit,
          size: 32,
        ),
      );

  Widget buildSwipeActionRight() => Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(
          Icons.delete_forever,
          size: 32,
        ),
      );
}
