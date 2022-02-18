import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../entities/event.dart';
import '../../../utils/constants/colors.dart';
import 'favorite_button.dart';

class ListItem extends StatefulWidget {
  final Event event;
  final TextEditingController textController;
  final Function onEventSelected;
  ListItem({
    Key? key,
    required this.event,
    required this.onEventSelected,
    required this.textController,
  }) : super(key: key);
  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  bool _isEditing = false;
  @override
  Widget build(BuildContext context) {
    final date = DateFormat.jm().format(widget.event.eventDate).toString();
    final isRight = widget.event.isRight;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isRight) FavoriteButton(event: widget.event),
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            widget.onEventSelected(widget.event);
          },
          onLongPress: () {
            _isEditing = true;
            widget.textController.text = widget.event.content;
            setState(() {});
          },
          child: Container(
            constraints: BoxConstraints.loose(
              Size(MediaQuery.of(context).size.width / 2, double.infinity),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: isRight
                  ? CustomColors.rightMessageColor
                  : CustomColors.leftMessageColor,
            ),
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  widget.event.content,
                  style: Theme.of(context).textTheme.bodyLarge,
                  toolbarOptions:
                      const ToolbarOptions(copy: true, selectAll: true),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(date, style: Theme.of(context).textTheme.caption),
                    if (widget.event.isSelected)
                      const Icon(
                        Icons.check,
                        size: 16,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (!isRight) FavoriteButton(event: widget.event),
        if (_isEditing)
          IconButton(
            icon: const Icon(
              Icons.check_circle,
              color: Colors.green,
            ),
            onPressed: () {
              if (widget.textController.text.isNotEmpty) {
                widget.event.content = widget.textController.text;
                widget.textController.text = '';
              }
              _isEditing = false;
              setState(() {});
            },
          ),
      ],
    );
  }
}
