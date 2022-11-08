import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../home/cubit/home_cubit.dart';
import '../../home/home_entity/chat_card.dart';
import '../../themes/theme_changer.dart';
import '../chat_entity/message.dart';
import '../cubit/chat_cubit.dart';
import 'filter_changer.dart';

class ChatView extends StatelessWidget {
  const ChatView({
    super.key,
    required this.chatTitle,
  });

  final String chatTitle;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeChanger.of(context).theme;
    return BlocBuilder<MessageCubit, List<Message>>(
      builder: (context, state) {
        final isSelectedList = state.where((element) => element.isSelected);
        final int selectedAmount = isSelectedList.length;
        return Scaffold(
          appBar: FilterChanger.of(context).stateWidget.isFiltered
              ? AppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      FilterChanger.of(context).stateWidget
                        ..filterOff()
                        ..filter = '';
                      context
                          .read<MessageCubit>()
                          .filterMessages('', chatTitle);
                    },
                  ),
                  title: selectedAmount == 0
                      ? AppBarTextField(
                          chatTitle: chatTitle,
                        )
                      : const SizedBox(),
                  actions: [
                    _AppBarButtonsBuilder(
                      chatTitle: chatTitle,
                      selectedAmount: selectedAmount,
                    ),
                  ],
                )
              : AppBar(
                  leading: selectedAmount >= 1
                      ? IconButton(
                          icon: const Icon(Icons.cancel_outlined),
                          onPressed: () => context
                              .read<MessageCubit>()
                              .unselectAllMessages(chatTitle),
                        )
                      : null,
                  actions: [
                    _AppBarButtonsBuilder(
                      isFiltered: true,
                      chatTitle: chatTitle,
                      selectedAmount: selectedAmount,
                    ),
                  ],
                  title: Text(chatTitle),
                ),
          body: Container(
            color: theme.brightness == Brightness.light
                ? theme.primaryColorLight
                : theme.primaryColorDark,
            child: SafeArea(
              child: Column(
                children: [
                  _MessagesBuilder(
                    chatTitle: chatTitle,
                  ),
                  FilterChanger.of(context).stateWidget.isFiltered
                      ? const SizedBox()
                      : _TextField(
                          key: UniqueKey(),
                          messages: state,
                          chatTitle: chatTitle,
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

class _MessageTile extends StatelessWidget {
  const _MessageTile({
    Key? key,
    required this.message,
  }) : super(key: key);

  final Message message;

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
            color: ThemeChanger.of(context).theme.primaryColorLight,
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
  const _SubmitButton({
    Key? key,
    required this.controller,
    required this.chatTitle,
    required this.onEdit,
  }) : super(key: key);

  final TextEditingController controller;
  final String chatTitle;
  final bool onEdit;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (controller.text.isNotEmpty) {
          if (onEdit) {
            context
                .read<MessageCubit>()
                .editMessage(controller.text, chatTitle);
            context.read<MessageCubit>().completeEditMessage(chatTitle);
          } else {
            context
                .read<MessageCubit>()
                .addMessage(newMessage: controller.text, chatTitle: chatTitle);
          }
          controller.clear();
        }
      },
      icon: const Icon(Icons.arrow_forward),
    );
  }
}

class _TextField extends StatefulWidget {
  const _TextField({
    Key? key,
    required this.chatTitle,
    required this.messages,
  }) : super(key: key);

  final List<Message> messages;
  final String chatTitle;

  @override
  State<_TextField> createState() => _TextFieldState();
}

class _TextFieldState extends State<_TextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final int editableMessageIndex =
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
    final int editableMessageIndex =
        widget.messages.indexWhere((element) => element.onEdit);
    final bool onEdit = editableMessageIndex != -1 ? true : false;
    final ThemeData theme = ThemeChanger.of(context).theme;
    return Container(
      color: theme.brightness == Brightness.light
          ? theme.primaryColorLight
          : theme.primaryColorDark,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Write your event',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: theme.brightness == Brightness.light
                        ? theme.primaryColorLight
                        : theme.primaryColorDark,
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: theme.brightness == Brightness.light
                        ? theme.primaryColorLight
                        : theme.primaryColorDark,
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: theme.brightness == Brightness.light
                        ? theme.primaryColorLight
                        : theme.primaryColorDark,
                    width: 2.0,
                  ),
                ),
              ),
            ),
          ),
          _SubmitButton(
            controller: _controller,
            chatTitle: widget.chatTitle,
            onEdit: onEdit,
          ),
        ],
      ),
    );
  }
}

class _MessagesBuilder extends StatelessWidget {
  const _MessagesBuilder({
    Key? key,
    required this.chatTitle,
  }) : super(key: key);

  final String chatTitle;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeChanger.of(context).theme;
    return Expanded(
      child: Container(
        color: theme.brightness == Brightness.light
            ? theme.primaryColor
            : theme.primaryColorDark,
        child: BlocBuilder<MessageCubit, List<Message>>(
          builder: (BuildContext context, state) {
            return ListView.builder(
              reverse: true,
              itemCount: state.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onLongPress: () {
                    context.read<MessageCubit>().selectMessage(
                          state.indexOf(
                            state.reversed.elementAt(index),
                          ),
                          chatTitle,
                        );
                    if (FilterChanger.of(context).stateWidget.isFiltered) {
                      final String filter =
                          FilterChanger.of(context).stateWidget.filter;
                      context
                          .read<MessageCubit>()
                          .filterMessages(filter, chatTitle);
                    }
                  },
                  child: DismissibleMessage(
                    message: state[index],
                    onDismissed: (DismissDirection direction) {
                      switch (direction) {
                        case DismissDirection.startToEnd:
                          context.read<MessageCubit>().selectMessage(
                                state.indexOf(state.reversed.elementAt(index)),
                                chatTitle,
                              );
                          context
                              .read<MessageCubit>()
                              .startEditMessage(chatTitle);
                          //context.read<MessageCubit>().editMessage(state[index].text, chatTitle);
                          break;
                        case DismissDirection.endToStart:
                          context.read<MessageCubit>().selectMessage(
                            state.indexOf(state.reversed.elementAt(index)),
                            chatTitle,
                          );
                          context
                              .read<MessageCubit>()
                              .deleteSelectedMessage(chatTitle);
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
  const _AppBarButtonsBuilder({
    Key? key,
    required this.selectedAmount,
    required this.chatTitle,
    this.isFiltered = false,
  }) : super(key: key);

  final String chatTitle;
  final int selectedAmount;
  final bool isFiltered;

  List<IconButton> _getAppBarButtons(BuildContext context, int selectedAmount) {
    List<IconButton> appBarButtonList = [];
    if (selectedAmount == 0 && isFiltered) {
      appBarButtonList.add(
        IconButton(
          onPressed: () => FilterChanger.of(context).stateWidget.filterOn(),
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
                chatTitle: chatTitle,
                messageContext: context,
              ),
            );
          },
          icon: const Icon(Icons.reply),
        ),
      );
      appBarButtonList.add(
        IconButton(
          onPressed: () =>
              context.read<MessageCubit>().deleteSelectedMessage(chatTitle),
          icon: const Icon(Icons.delete),
        ),
      );
    }
    if (selectedAmount == 1) {
      if (isFiltered) {
        appBarButtonList.add(
          IconButton(
            onPressed: () =>
                context.read<MessageCubit>().startEditMessage(chatTitle),
            icon: const Icon(Icons.edit),
          ),
        );
      }
      appBarButtonList.add(
        IconButton(
          onPressed: () => context.read<MessageCubit>().copyMessage(chatTitle),
          icon: const Icon(Icons.copy),
        ),
      );
    }
    return appBarButtonList;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _getAppBarButtons(context, selectedAmount),
    );
  }
}

class AppBarTextField extends StatefulWidget {
  const AppBarTextField({
    Key? key,
    required this.chatTitle,
  }) : super(key: key);

  final String chatTitle;

  @override
  State<AppBarTextField> createState() => _AppBarTextFieldState();
}

class _AppBarTextFieldState extends State<AppBarTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: (filter) {
        context.read<MessageCubit>().filterMessages(filter, widget.chatTitle);
        FilterChanger.of(context).stateWidget.filter = filter;
      },
    );
  }
}

class ShearingDialog extends StatefulWidget {
  const ShearingDialog({
    Key? key,
    required this.chatTitle,
    required this.messageContext,
  }) : super(key: key);

  final String chatTitle;
  final BuildContext messageContext;

  @override
  State<ShearingDialog> createState() => _ShearingDialogState();
}

class _ShearingDialogState extends State<ShearingDialog> {
  String _radioValue = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
          'Select the page you want to migrate the selected event(S) to!'),
      content: SizedBox(
        width: 300,
        height: 300,
        child: BlocBuilder<HomeCubit, List<ChatCard>>(
          builder: (context, state) {
            return ListView.builder(
              itemCount: state.length,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  children: [
                    Radio(
                      value: state[index].title,
                      groupValue: _radioValue,
                      onChanged: (value) {
                        setState(() {
                          _radioValue = value!;
                        });
                      },
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
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            widget.messageContext
                .read<MessageCubit>()
                .migrateMessages(widget.chatTitle, _radioValue);
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
