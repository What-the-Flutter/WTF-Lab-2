import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashtagable/widgets/hashtag_text.dart';

import '../../../utils/message.dart';
import '../../pages/chat_page/cubit/chat_cubit.dart';
import '../../settings/cubit/settings_cubit/settings_cubit.dart';
import '../../settings/theme.dart';

class BodyWithMessages extends StatelessWidget {
  final List<Message> messages;

  const BodyWithMessages({
    Key? key,
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
          reverse: true,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final revIndexTime = messages.reversed.elementAt(index).sentTime;
            final nextRevIndexTime = index == messages.length - 1
                ? messages.reversed.elementAt(0).sentTime
                : messages.reversed.elementAt(index + 1).sentTime;
            return Column(
              children: [
                (revIndexTime.difference(nextRevIndexTime).inDays == 0)
                    ? const SizedBox()
                    : _DateBubble(date: revIndexTime),
                _DismissibleMessageTile(messages: messages, index: index),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _DateBubble extends StatelessWidget {
  final DateTime date;

  const _DateBubble({
    Key? key,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = context.read<SettingsCubit>().state;
    return Align(
      alignment: state.isCenterDateAlignment
          ? Alignment.center
          : state.bubbleAlignment == BubbleAlignment.left
              ? Alignment.centerLeft
              : Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: theme.brightness == Brightness.dark
              ? theme.primaryColor
              : theme.primaryColorDark,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          '${date.day.toString()}.'
          '${date.month.toString()}.'
          '${date.year.toString()}',
          style: getBodyText(
            context.read<SettingsCubit>().state.textSize,
            context,
          ),
        ),
      ),
    );
  }
}

class _DismissibleMessageTile extends StatelessWidget {
  final List<Message> messages;
  final int index;

  const _DismissibleMessageTile(
      {Key? key, required this.messages, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => context.read<ChatCubit>().selectMessage(
            messages.reversed.elementAt(index),
          ),
      child: _DismissibleMessage(
        message: messages[index],
        onDismissed: (direction) {
          direction == DismissDirection.startToEnd
              ? context
                  .read<ChatCubit>()
                  .startEditMessage(messages.reversed.elementAt(index))
              : context
                  .read<ChatCubit>()
                  .deleteMessage(messages.reversed.elementAt(index));
        },
        child: _MessageTile(
          message: messages.reversed.elementAt(index),
        ),
      ),
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
    final alignment = context.read<SettingsCubit>().state.bubbleAlignment;
    return Row(
      mainAxisAlignment: alignment == BubbleAlignment.left
          ? MainAxisAlignment.start
          : MainAxisAlignment.end,
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
                    child: HashTagText(
                      text: message.text,
                      basicStyle: getTitleText(
                        context.read<SettingsCubit>().state.textSize,
                        context,
                      ),
                      decoratedStyle: getTitleText(
                        context.read<SettingsCubit>().state.textSize,
                        context,
                      ).copyWith(color: Colors.blue),
                      overflow: TextOverflow.clip,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    children: [
                      Text(
                        '${message.sentTime.hour} : ${message.sentTime.minute}',
                        style: const TextStyle(fontSize: 9),
                      ),
                      message.isBookmarked
                          ? const Icon(Icons.bookmark, size: 10)
                          : const SizedBox(),
                    ],
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
