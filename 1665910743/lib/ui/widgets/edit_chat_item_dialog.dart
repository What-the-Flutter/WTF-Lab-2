import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/category_list_cubit.dart';
import '../../cubit/category_list_state.dart';

Future<void> chatTileEditDialog({
  required BuildContext context,
  required int catIndex,
  required int index,
  required String title,
}) async {
  return showDialog(
      context: context,
      builder: (context) => EditChatTile(
            title: title,
            context: context,
            index: index,
            catIndex: catIndex,
          ));
}

class EditChatTile extends StatefulWidget {
  final BuildContext context;
  final int catIndex;
  final int index;
  final String title;
  const EditChatTile({
    Key? key,
    required this.context,
    required this.index,
    required this.catIndex,
    required this.title,
  }) : super(key: key);

  @override
  State<EditChatTile> createState() => _EditChatTileState();
}

class _EditChatTileState extends State<EditChatTile> {
  final _renameController = TextEditingController();

  @override
  void dispose() {
    _renameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CategoryListCubit>().state;

    return AlertDialog(
      elevation: 5,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(25.0),
        ),
      ),
      title: const Center(child: Text('Rename your event')),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        _bookmarkButton(context, state, widget.title),
        _renameButton(context, state, widget.title),
        _deleteButton(context, state)
      ],
      content: TextField(
        controller: _renameController,
      ),
    );
  }

  CircleAvatar _deleteButton(BuildContext context, CategoryListState state) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      child: IconButton(
        onPressed: () {
          Navigator.pop(context);
          context.read<CategoryListCubit>().removeEventInCategory(
                categoryIndex: widget.catIndex,
                eventIndex: widget.index,
                title: widget.title,
              );
        },
        icon: const Icon(Icons.delete_forever),
      ),
    );
  }

  ElevatedButton _renameButton(
    BuildContext context,
    CategoryListState state,
    String title,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).primaryColor,
      ),
      onPressed: () {
        Navigator.pop(context);
        context.read<CategoryListCubit>().eventRename(
              title: title,
              categoryIndex: widget.catIndex,
              eventIndex: widget.index,
              newTitle: _renameController.text,
            );
      },
      child: const Text(
        'Rename',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  CircleAvatar _bookmarkButton(
    BuildContext context,
    CategoryListState state,
    String title,
  ) {
    return CircleAvatar(
      foregroundColor: Colors.white,
      backgroundColor: Theme.of(context).primaryColor,
      child: IconButton(
        onPressed: () {
          Navigator.pop(context);
          context.read<CategoryListCubit>().bookMarkEvent(
                title: title,
                categoryIndex: widget.catIndex,
                eventIndex: widget.index,
              );
        },
        icon: state.categoryList[widget.catIndex].list[widget.index].favorite
            ? const Icon(Icons.bookmark)
            : const Icon(Icons.bookmark_border),
      ),
    );
  }
}
