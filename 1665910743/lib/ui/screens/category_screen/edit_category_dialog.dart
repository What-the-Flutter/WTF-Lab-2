import 'package:flutter/material.dart';

import '../../../models/event_category.dart';
import 'cubit/category_cubit.dart';

Future<void> displayTextInputDialog({
  required CategoryCubit categoryCubit,
  required BuildContext context,
  required EventCategory category,
  required bool pinned,
  required String key,
}) async {
  return showDialog(
      context: context,
      builder: (context) => EditDialog(
            cubit: categoryCubit,
            context: context,
            category: category,
            pinned: pinned,
            dbKey: key,
          ));
}

class EditDialog extends StatefulWidget {
  final CategoryCubit cubit;
  final BuildContext context;
  final bool pinned;
  final EventCategory category;
  final String dbKey;

  const EditDialog({
    Key? key,
    required this.context,
    required this.pinned,
    required this.category,
    required this.dbKey,
    required this.cubit,
  }) : super(key: key);

  @override
  State<EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
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
        _pinButton(
          context,
          widget.cubit,
        ),
        _renameButton(
          context,
          widget.cubit,
          widget.category.title,
        ),
        _deleteButton(
          context,
          widget.cubit,
        )
      ],
      content: TextField(
        style: TextStyle(color: Theme.of(context).primaryColor),
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).primaryColor, width: 1),
          ),
        ),
        controller: _controller,
      ),
    );
  }

  Widget _renameButton(
    BuildContext context,
    CategoryCubit cubit,
    String oldTitle,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).primaryColor,
      ),
      onPressed: () {
        Navigator.pop(context);
        cubit.categoryRename(
          oldTitle: oldTitle,
          key: widget.dbKey,
          newTitle: _controller.text,
        );
      },
      child: const Text(
        'Rename',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _deleteButton(
    BuildContext context,
    CategoryCubit cubit,
  ) {
    return CircleAvatar(
      foregroundColor: Colors.white,
      backgroundColor: Theme.of(context).primaryColor,
      child: IconButton(
        onPressed: () {
          cubit.remove(widget.category, widget.dbKey);
          Navigator.pop(context);
        },
        icon: const Icon(Icons.delete_forever),
      ),
    );
  }

  Widget _pinButton(
    BuildContext context,
    CategoryCubit cubit,
  ) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      child: IconButton(
          onPressed: () {
            Navigator.pop(context);
            if (widget.category.pinned == false) {
              cubit.pin(
                widget.category,
                widget.dbKey,
              );
            } else {
              cubit.unpin(
                widget.category,
                widget.dbKey,
              );
            }
          },
          icon: Icon(widget.pinned ? Icons.push_pin : Icons.push_pin_outlined)),
    );
  }
}
