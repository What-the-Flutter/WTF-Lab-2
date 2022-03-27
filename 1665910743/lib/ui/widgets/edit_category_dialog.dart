import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/categorylist_cubit.dart';
import '../../cubit/categorylist_state.dart';

Future<void> displayTextInputDialog({
  required BuildContext context,
  required int categryIndex,
  required EventCategory category,
  required bool pined,
}) async {
  return showDialog(
      context: context,
      builder: (context) => EditDialog(
            categoryIndex: categryIndex,
            context: context,
            category: category,
            pinned: pined,
          ));
}

class EditDialog extends StatefulWidget {
  final BuildContext context;
  final int categoryIndex;
  final bool pinned;
  final EventCategory category;

  const EditDialog({
    Key? key,
    required this.context,
    required this.categoryIndex,
    required this.pinned,
    required this.category,
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
    final cubit = context.read<CategorylistCubit>();
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
        _pinButton(context, cubit),
        _renameButton(context, cubit),
        _deleteButton(context, cubit)
      ],
      content: TextField(
        controller: _controller,
      ),
    );
  }

  ElevatedButton _renameButton(BuildContext context, CategorylistCubit cubit) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).primaryColor,
      ),
      onPressed: () {
        Navigator.pop(context);
        context.read<CategorylistCubit>().categoryRename(
              categoryIndex: widget.categoryIndex,
              newTitle: _controller.text,
            );
      },
      child: const Text(
        'Rename',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  CircleAvatar _deleteButton(BuildContext context, CategorylistCubit cubit) {
    return CircleAvatar(
      foregroundColor: Colors.white,
      backgroundColor: Theme.of(context).primaryColor,
      child: IconButton(
        onPressed: () {
          if (cubit.state.categoryList[widget.categoryIndex].pined == false) {
            context.read<CategorylistCubit>().remove(widget.category);
          } else {
            context.read<CategorylistCubit>().unpin(widget.category);
            context.read<CategorylistCubit>().remove(widget.category);
          }
          Navigator.pop(context);
        },
        icon: const Icon(Icons.delete_forever),
      ),
    );
  }

  Widget _pinButton(BuildContext context, CategorylistCubit cubit) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      child: IconButton(
        onPressed: () {
          if (widget.category.pined == false) {
            widget.category.pined = true;
            context.read<CategorylistCubit>().pin(widget.category);
            context.read<CategorylistCubit>().remove(widget.category);
          } else {
            widget.category.pined = false;
            context.read<CategorylistCubit>().unpin(widget.category);
          }

          Navigator.pop(context);
        },
        icon: widget.pinned
            ? const Icon(Icons.push_pin)
            : const Icon(Icons.push_pin_outlined),
      ),
    );
  }
}
