import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../pages/chat_page/cubit/chat_cubit.dart';
import '../../pages/home_page/cubit/home_cubit.dart';
import '../../settings/cubit/settings_cubit/settings_cubit.dart';
import '../../settings/theme.dart';

AppBar getAppBar({
  required BuildContext context,
  required MessagesState state,
  required String title,
  String? chatId,
}) {
  final isSelectedList = state.messages.where((element) => element.isSelected);
  final selectedAmount = isSelectedList.length;
  return state.filter.isFiltered
      ? _filterAppBar(context, selectedAmount, chatId)
      : _commonAppBar(context, selectedAmount, title);
}

AppBar _commonAppBar(BuildContext context, int selectedAmount, String title) {
  return AppBar(
    leading: selectedAmount >= 1 ? _cancelSelectedButton(context) : null,
    actions: [
      _AppBarButtons(
        isFiltered: true,
        selectedAmount: selectedAmount,
      ),
    ],
    title: selectedAmount == 0
        ? Text(
            title,
            style: getHeadLineText(
              context.read<SettingsCubit>().state.textSize,
              context,
            ),
          )
        : null,
  );
}

IconButton _cancelSelectedButton(BuildContext context) {
  return IconButton(
    icon: const Icon(Icons.cancel_outlined),
    onPressed: () => context.read<MessageCubit>().unselectAllMessages(),
  );
}

AppBar _filterAppBar(BuildContext context, int selectedAmount, String? chatId) {
  final hashTagFilters = chatId == null
      ? context.read<MessageCubit>().getHashTagFilters()
      : context.read<MessageCubit>().getHashTagFiltersFromChat(chatId);
  return AppBar(
    leading: _filterBackButton(context),
    title: selectedAmount == 0 ? const _AppBarTextField() : const SizedBox(),
    actions: [
      _AppBarButtons(selectedAmount: selectedAmount),
    ],
    bottom: hashTagFilters.isNotEmpty
        ? PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: _HashTagFilters(hashTags: hashTagFilters),
          )
        : null,
  );
}

IconButton _filterBackButton(BuildContext context) {
  return IconButton(
    icon: const Icon(Icons.arrow_back_ios),
    onPressed: () {
      context.read<MessageCubit>().deleteFilter();
    },
  );
}

class _AppBarButtons extends StatelessWidget {
  final int selectedAmount;
  final bool isFiltered;

  const _AppBarButtons({
    Key? key,
    required this.selectedAmount,
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
          onPressed: () => context.read<MessageCubit>().setBookmarkFilter(),
          icon: context.read<MessageCubit>().state.filter.isBookmarkFilterOn
              ? const Icon(Icons.bookmark)
              : const Icon(Icons.bookmark_outline),
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
      appBarButtonList.add(
        IconButton(
          onPressed: () => context.read<MessageCubit>().changeBookmark(),
          icon: const Icon(Icons.bookmark),
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
  const _AppBarTextField({Key? key}) : super(key: key);

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
        context.read<MessageCubit>().setFilter(filter);
      },
    );
  }
}

class _ShearingDialog extends StatefulWidget {
  final BuildContext messageContext;

  const _ShearingDialog({
    Key? key,
    required this.messageContext,
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
      title: Text(
        'Select the page you want to migrate the selected event(S) to!',
        style: getTitleText(
          context.read<SettingsCubit>().state.textSize,
          context,
        ),
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
                    Text(
                      state.chatCards[index].title,
                      style: getBodyText(
                        context.read<SettingsCubit>().state.textSize,
                        context,
                      ),
                    ),
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
          child: Text(
            'Cancel',
            style: getBodyText(
              context.read<SettingsCubit>().state.textSize,
              context,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            widget.messageContext
                .read<MessageCubit>()
                .migrateMessages(_radioValue);
            Navigator.pop(context);
          },
          child: Text(
            'Confirm',
            style: getBodyText(
              context.read<SettingsCubit>().state.textSize,
              context,
            ),
          ),
        ),
      ],
    );
  }
}

class _HashTagFilters extends StatefulWidget {
  final List<String> hashTags;

  const _HashTagFilters({
    Key? key,
    required this.hashTags,
  }) : super(key: key);

  @override
  State<_HashTagFilters> createState() => _HashTagFiltersState();
}

class _HashTagFiltersState extends State<_HashTagFilters> {
  bool favorite = false;
  final List<String> _filters = <String>[];

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 5.0),
          SizedBox(
            height: 50,
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 5.0,
                children: widget.hashTags.map(
                  (hashTag) {
                    return FilterChip(
                      label: Text(hashTag),
                      selected: _filters.contains(hashTag),
                      onSelected: (value) {
                        setState(() {
                          if (value) {
                            if (!_filters.contains(hashTag)) {
                              _filters.add(hashTag);
                            }
                          } else {
                            _filters.removeWhere(
                              (name) {
                                return name == hashTag;
                              },
                            );
                          }
                          context
                              .read<MessageCubit>()
                              .addHashTagFilters(_filters);
                        });
                      },
                    );
                  },
                ).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
