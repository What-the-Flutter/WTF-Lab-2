import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/category_cubit/category_list_cubit.dart';
import '../../models/event_category.dart';

Future<void> displayTextInputDialog({
  required BuildContext context,
  required EventCategory category,
  required bool pinned,
  required String key,
}) async {
  return showDialog(
      context: context,
      builder: (context) => EditDialog(
            context: context,
            category: category,
            pinned: pinned,
            dbKey: key,
          ));
}

class EditDialog extends StatefulWidget {
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
  }) : super(key: key);

  @override
  State<EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CategoryListCubit>();
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
        _pinButton(
          context,
          cubit,
        ),
        _renameButton(
          context,
          cubit,
        ),
        _deleteButton(
          context,
          cubit,
        )
      ],
      content: TextField(
        controller: _controller,
      ),
    );
  }

  Widget _renameButton(BuildContext context, CategoryListCubit cubit) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).primaryColor,
      ),
      onPressed: () {
        Navigator.pop(context);
        context.read<CategoryListCubit>().categoryRename(
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
    CategoryListCubit cubit,
  ) {
    return CircleAvatar(
      foregroundColor: Colors.white,
      backgroundColor: Theme.of(context).primaryColor,
      child: IconButton(
        onPressed: () {
          context
              .read<CategoryListCubit>()
              .unpin(widget.category, widget.dbKey);
          context
              .read<CategoryListCubit>()
              .remove(widget.category, widget.dbKey);

          Navigator.pop(context);
        },
        icon: const Icon(Icons.delete_forever),
      ),
    );
  }

  Widget _pinButton(
    BuildContext context,
    CategoryListCubit cubit,
  ) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      child: IconButton(
        onPressed: () {
          Navigator.pop(context);

          if (widget.category.pinned == false) {
            
            setState(() {
              context.read<CategoryListCubit>().pin(
                    widget.category,
                    widget.dbKey,
                  );
            });
          } else {
            
            setState(() {
              context.read<CategoryListCubit>().unpin(
                    widget.category,
                    widget.dbKey,
                  );
            });
          }
        },
        icon: widget.pinned
            ? const Icon(Icons.push_pin)
            : const Icon(Icons.push_pin_outlined),
      ),
    );
  }
}
