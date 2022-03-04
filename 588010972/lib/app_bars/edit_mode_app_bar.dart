import 'package:flutter/material.dart';

class EditModeAppBar extends StatefulWidget implements PreferredSizeWidget {
  final int chosenForEditEvent;
  final Function copy;
  final int index;
  final Function() close;
  final Function delete;
  final Function() editionStart;
  final Function editionConfirm;

  const EditModeAppBar({
    Key? key,
    required this.index,
    required this.chosenForEditEvent,
    required this.copy,
    required this.close,
    required this.delete,
    required this.editionStart,
    required this.editionConfirm,
  }) : super(key: key);

  @override
  _EditModeAppBarState createState() => _EditModeAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(50);
}

class _EditModeAppBarState extends State<EditModeAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(
          Icons.cancel,
        ),
        onPressed: widget.close,
      ),
      title: Align(
        alignment: Alignment.center,
        child: Text(
          widget.chosenForEditEvent.toString(),
        ),
      ),
      actions: [
        const IconButton(
          icon: Icon(
            Icons.send,
          ),
          onPressed: null,
        ),
        IconButton(
          icon: const Icon(
            Icons.edit,
          ),
          onPressed: widget.editionStart,
        ),
        IconButton(
          icon: const Icon(
            Icons.copy,
          ),
          onPressed: () {
            widget.copy(widget.index);
          },
        ),
        const IconButton(
          icon: Icon(
            Icons.bookmark_border,
          ),
          onPressed: null,
        ),
        IconButton(
          icon: const Icon(
            Icons.delete,
          ),
          onPressed: () {
            widget.delete(widget.index);
          },
        ),
      ],
    );
  }
}
