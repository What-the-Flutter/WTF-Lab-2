import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/home_cubit.dart';
import '../models/theme_cubit.dart';
import '../utils/chat_card.dart';
import 'chat_view.dart';
import 'new_chat_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, ChatsState>(
      builder: (context, state) {
        final isSelectedList =
            state.chatCards.where((element) => element.isSelected);
        final selectedAmount = isSelectedList.length;
        return Scaffold(
          appBar: AppBar(
            leading:
                selectedAmount >= 1 ? cancelSelectionButton(context) : null,
            actions: [
              _AppBarButtonsBuilder(
                selectedAmount: selectedAmount,
              ),
            ],
            title: const Text('Home'),
          ),
          body: ListView.builder(
            itemCount: state.chatCards.length,
            itemBuilder: (context, index) {
              return _ChatCardBuilder(
                chatCard: state.chatCards[index],
                index: index,
                selectedAmount: selectedAmount,
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NewChatView(),
                ),
              );
            },
          ),
        );
      },
    );
  }

  IconButton cancelSelectionButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.cancel_outlined),
      onPressed: () => context.read<HomeCubit>().unselectAllChats(),
    );
  }
}

class _ChatCardBuilder extends StatelessWidget {
  final int index;
  final int selectedAmount;
  final ChatCard chatCard;

  const _ChatCardBuilder({
    Key? key,
    required this.chatCard,
    required this.index,
    required this.selectedAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onLongPress: () => context.read<HomeCubit>().selectChat(chatCard),
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: theme.brightness == Brightness.light
                ? theme.primaryColorLight
                : theme.primaryColor,
            child: chatCard.icon,
          ),
          title: Text(chatCard.title),
          subtitle: Text(chatCard.subtitle),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatView(
                  chatCard: chatCard,
                ),
              ),
            );
          },
          trailing: chatCard.isSelected ? const Icon(Icons.check) : null,
        ),
      ),
    );
  }
}

class _AppBarButtonsBuilder extends StatelessWidget {
  final int selectedAmount;

  const _AppBarButtonsBuilder({
    Key? key,
    required this.selectedAmount,
  }) : super(key: key);

  List<IconButton> _getAppBarButtons(BuildContext context, int selectedAmount) {
    final appBarButtonList = <IconButton>[];
    if (selectedAmount == 0) {
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
          onPressed: () => context.read<HomeCubit>().deleteSelectedChats(),
          icon: const Icon(Icons.delete),
        ),
      );
    }
    if (selectedAmount == 1) {
      appBarButtonList.add(
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NewChatView(),
              ),
            );
          },
          icon: const Icon(Icons.edit),
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
