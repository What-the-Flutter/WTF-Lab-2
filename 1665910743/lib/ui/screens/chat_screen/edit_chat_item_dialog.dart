import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../chat_screen/cubit/event_cubit.dart';

Future<void> chatTileEditDialog({
  required BuildContext context,
  required String title,
  required String key,
  required bool isBookmarked,
}) async {
  return showDialog(
    context: context,
    builder: (context) => EditChatTile(
      title: title,
      context: context,
      eventKey: key,
      isBookmarked: isBookmarked,
    ),
  );
}

class EditChatTile extends StatefulWidget {
  final BuildContext context;
  final bool isBookmarked;
  final String title;
  final String eventKey;

  const EditChatTile({
    Key? key,
    required this.context,
    required this.title,
    required this.eventKey,
    required this.isBookmarked,
  }) : super(key: key);

  @override
  State<EditChatTile> createState() => _EditChatTileState();
}

class _EditChatTileState extends State<EditChatTile> {
  final TextEditingController _renameController = TextEditingController();

  @override
  void dispose() {
    _renameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 5,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(25.0),
        ),
      ),
      title: Center(
        child: Text(
          'Rename your event',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        _bookmarkButton(
          context,
          widget.eventKey,
          widget.isBookmarked,
        ),
        _renameButton(context),
        _deleteButton(context)
      ],
      content: TextField(
        controller: _renameController,
      ),
    );
  }

  Widget _deleteButton(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      child: IconButton(
        onPressed: () {
          Navigator.pop(context);
          context.read<EventCubit>().removeEventInCategory(
                key: widget.eventKey,
              );
        },
        icon: const Icon(Icons.delete_forever),
      ),
    );
  }

  Widget _renameButton(
    BuildContext context,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).primaryColor,
      ),
      onPressed: () {
        Navigator.pop(context);
        context.read<EventCubit>().eventRename(
              key: widget.eventKey,
              newTitle: _renameController.text,
            );
      },
      child: const Text(
        'Rename',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _bookmarkButton(
    BuildContext context,
    String key,
    bool isBook,
  ) {
    return CircleAvatar(
      foregroundColor: Colors.white,
      backgroundColor: Theme.of(context).primaryColor,
      child: IconButton(
        onPressed: () async {
          Navigator.pop(context);
          context.read<EventCubit>().bookMarkEvent(key: key, isBook: isBook);
        },
        icon: Icon(
          widget.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
        ),
      ),
    );
  }
}
