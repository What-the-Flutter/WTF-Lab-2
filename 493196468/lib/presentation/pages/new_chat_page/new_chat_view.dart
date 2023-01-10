import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../settings/cubit/settings_cubit/settings_cubit.dart';
import '../../settings/theme.dart';
import '/utils/chat_card.dart';
import '../home_page/cubit/home_cubit.dart';
import 'cubit/new_chat_cubit.dart';

class NewChatView extends StatelessWidget {
  static const _icons = [
    Icon(IconData(0xe481, fontFamily: 'MaterialIcons')),
    Icon(IconData(0xe1bb, fontFamily: 'MaterialIcons')),
    Icon(IconData(0xef9f, fontFamily: 'MaterialIcons')),
    Icon(IconData(0xef9e, fontFamily: 'MaterialIcons')),
    Icon(IconData(0xf0797, fontFamily: 'MaterialIcons')),
    Icon(IconData(0xf04dc, fontFamily: 'MaterialIcons')),
    Icon(IconData(0xf06bc, fontFamily: 'MaterialIcons')),
    Icon(IconData(0xef8a, fontFamily: 'MaterialIcons')),
    Icon(IconData(0xe199, fontFamily: 'MaterialIcons')),
    Icon(IconData(0xf05d3, fontFamily: 'MaterialIcons')),
    Icon(IconData(0xf04d8, fontFamily: 'MaterialIcons')),
    Icon(IconData(0xef82, fontFamily: 'MaterialIcons')),
    Icon(IconData(0xe6f4, fontFamily: 'MaterialIcons')),
    Icon(IconData(0xf4d2, fontFamily: 'MaterialIcons')),
    Icon(IconData(0xf4d0, fontFamily: 'MaterialIcons')),
    Icon(IconData(0xf02bf, fontFamily: 'MaterialIcons')),
    Icon(IconData(0xe6e9, fontFamily: 'MaterialIcons')),
    Icon(IconData(0xf4c6, fontFamily: 'MaterialIcons')),
    Icon(IconData(0xe6e3, fontFamily: 'MaterialIcons')),
    Icon(IconData(0xf4c2, fontFamily: 'MaterialIcons')),
    Icon(IconData(0xf4bc, fontFamily: 'MaterialIcons')),
    Icon(IconData(0xf4b9, fontFamily: 'MaterialIcons')),
    Icon(IconData(0xf4b8, fontFamily: 'MaterialIcons')),
    Icon(IconData(0xedc6, fontFamily: 'MaterialIcons')),
    Icon(IconData(0xf4b2, fontFamily: 'MaterialIcons')),
    Icon(IconData(0xf4b1, fontFamily: 'MaterialIcons')),
    Icon(IconData(0xe6cc, fontFamily: 'MaterialIcons')),
    Icon(IconData(0xe6ca, fontFamily: 'MaterialIcons')),
    Icon(IconData(0xe140, fontFamily: 'MaterialIcons')),
    Icon(IconData(0xf4aa, fontFamily: 'MaterialIcons')),
    Icon(IconData(0xedbb, fontFamily: 'MaterialIcons')),
    Icon(IconData(0xf4a1, fontFamily: 'MaterialIcons')),
    Icon(IconData(0xf48c, fontFamily: 'MaterialIcons')),
    Icon(IconData(0xf488, fontFamily: 'MaterialIcons')),
    Icon(IconData(0xf47d, fontFamily: 'MaterialIcons')),
    Icon(IconData(0xf47c, fontFamily: 'MaterialIcons')),
    Icon(IconData(0xf478, fontFamily: 'MaterialIcons')),
    Icon(IconData(0xf476, fontFamily: 'MaterialIcons')),
    Icon(IconData(0xf46e, fontFamily: 'MaterialIcons')),
    Icon(IconData(0xf468, fontFamily: 'MaterialIcons')),
    Icon(IconData(0xe680, fontFamily: 'MaterialIcons')),
    Icon(IconData(0xf455, fontFamily: 'MaterialIcons')),
  ];

  const NewChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final editableChatCards = context.read<HomeCubit>().getSelectedChats();
    final onEdit = editableChatCards.isNotEmpty;
    if (onEdit) {
      context.read<NewChatCubit>().setChatCard(editableChatCards.first);
    }
    return BlocBuilder<NewChatCubit, ChatCard>(
      builder: (context, state) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            child: state.title.isEmpty
                ? const Icon(Icons.cancel_outlined)
                : const Icon(Icons.add),
            onPressed: () {
              if (state.title.isNotEmpty) {
                onEdit
                    ? context.read<HomeCubit>().editChat(state)
                    : context.read<HomeCubit>().addChat(newChatCard: state);
                context.read<NewChatCubit>().setChatCard(
                      ChatCard(
                        icon: _icons[0],
                        title: '',
                      ),
                    );
              }
              Navigator.pop(context);
            },
          ),
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 30),
                  child: Text(
                    onEdit ? 'Edit Chat' : 'Create a new Chat',
                    style: getHeadLineText(
                      context.read<SettingsCubit>().state.textSize,
                      context,
                    ),
                  ),
                ),
                _TitleTextField(
                  onEdit: onEdit,
                  editableChatCards: editableChatCards,
                ),
                _IconGrid(
                  icons: _icons,
                  state: state,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _IconGrid extends StatelessWidget {
  final List<Icon> _icons;
  final ChatCard state;

  const _IconGrid({
    Key? key,
    required List<Icon> icons,
    required this.state,
  })  : _icons = icons,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        itemCount: _icons.length,
        itemBuilder: (context, index) {
          return IconButton(
              onPressed: () =>
                  context.read<NewChatCubit>().setIcon(_icons[index]),
              color: state.icon.icon?.codePoint == _icons[index].icon?.codePoint
                  ? Colors.black
                  : null,
              icon: _icons[index]);
        },
      ),
    );
  }
}

class _TitleTextField extends StatelessWidget {
  final bool onEdit;
  final List<ChatCard> editableChatCards;

  const _TitleTextField({
    Key? key,
    required this.onEdit,
    required this.editableChatCards,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: onEdit ? editableChatCards.first.title : null,
      decoration: InputDecoration(
        hintText: 'Name',
        hintStyle: getTitleText(
          context.read<SettingsCubit>().state.textSize,
          context,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColorLight,
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColorLight,
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColorLight,
            width: 2.0,
          ),
        ),
      ),
      validator: (value) {
        if (value != null) {
          return value.isEmpty ? 'Message is empty' : null;
        } else {
          return 'Message is empty';
        }
      },
      onChanged: (value) => context.read<NewChatCubit>().setText(value),
    );
  }
}
