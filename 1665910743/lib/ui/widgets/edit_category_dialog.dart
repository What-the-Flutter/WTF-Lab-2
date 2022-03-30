import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/category_list_cubit.dart';
import '../../models/event_category.dart';

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
          widget.categoryIndex,
        ),
        _renameButton(
          context,
          cubit,
        ),
        _deleteButton(
          context,
          cubit,
          widget.categoryIndex,
        )
      ],
      content: TextField(
        controller: _controller,
      ),
    );
  }

  ElevatedButton _renameButton(BuildContext context, CategoryListCubit cubit) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).primaryColor,
      ),
      onPressed: () {
        Navigator.pop(context);
        context.read<CategoryListCubit>().categoryRename(
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

  CircleAvatar _deleteButton(
      BuildContext context, CategoryListCubit cubit, int catIndex) {
    return CircleAvatar(
      foregroundColor: Colors.white,
      backgroundColor: Theme.of(context).primaryColor,
      child: IconButton(
        onPressed: () {
          if (cubit.state.categoryList[widget.categoryIndex].pined == false) {
            context.read<CategoryListCubit>().remove(widget.category);
          } else {
            context.read<CategoryListCubit>().unpin(widget.category, catIndex);
            context.read<CategoryListCubit>().remove(widget.category);
          }
          Navigator.pop(context);
        },
        icon: const Icon(Icons.delete_forever),
      ),
    );
  }

  Widget _pinButton(
      BuildContext context, CategoryListCubit cubit, int catIndex) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      child: IconButton(
        onPressed: () {
          Navigator.pop(context);

          if (widget.category.pined == false) {
            widget.category.pined = true;
            context.read<CategoryListCubit>().pin(
                  widget.category,
                  catIndex,
                );
          } else {
            widget.category.pined = false;
            context.read<CategoryListCubit>().unpin(
                  widget.category,
                  catIndex,
                );
          }
        },
        icon: widget.pinned
            ? const Icon(Icons.push_pin)
            : const Icon(Icons.push_pin_outlined),
      ),
    );
  }
}
