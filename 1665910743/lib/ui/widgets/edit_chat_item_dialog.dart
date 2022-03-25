import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/categorylist_cubit.dart';
import '../../cubit/categorylist_state.dart';

Future<void> chatTileEditDialog({
  required BuildContext context,
  required int catIndex,
  required int index,
}) async {
  return showDialog(
      context: context,
      builder: (context) => EditChatTile(
            context: context,
            index: index,
            catIndex: catIndex,
          ));
}

class EditChatTile extends StatefulWidget {
  final BuildContext context;
  final int catIndex;
  final int index;
  const EditChatTile({
    Key? key,
    required this.context,
    required this.index,
    required this.catIndex,
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
    final state = context.watch<CategorylistCubit>().state;

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
        _bookmarkButton(context, state),
        _renameButton(context, state),
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
          context.read<CategorylistCubit>().removeEventInCategory(
                categoryIndex: widget.catIndex,
                eventIndex: widget.index,
              );
        },
        icon: const Icon(Icons.delete_forever),
      ),
    );
  }

  ElevatedButton _renameButton(BuildContext context, CategoryListState state) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).primaryColor,
      ),
      onPressed: () {
        Navigator.pop(context);
        context.read<CategorylistCubit>().eventRename(
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

  CircleAvatar _bookmarkButton(BuildContext context, CategoryListState state) {
    return CircleAvatar(
      foregroundColor: Colors.white,
      backgroundColor: Theme.of(context).primaryColor,
      child: IconButton(
        onPressed: () {
          setState(() {
            state.categoryList[widget.catIndex].list[widget.index].favorite =
                !state
                    .categoryList[widget.catIndex].list[widget.index].favorite;
            Navigator.pop(context);
          });
        },
        icon: state.categoryList[widget.catIndex].list[widget.index].favorite
            ? const Icon(Icons.bookmark)
            : const Icon(Icons.bookmark_border),
      ),
    );
  }
}
