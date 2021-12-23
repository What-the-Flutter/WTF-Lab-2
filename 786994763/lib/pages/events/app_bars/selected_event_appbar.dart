import 'package:flutter/material.dart';
import '../../../models/event.dart';
import '../const_widgets.dart';

class EventSelectedAppBar extends StatefulWidget {
  final List<Event> eventsList;
  final int selectedIndex;
  final int amountSelectedEvents;
  final Function countSelectedEvents;
  final Function removeEvent;
  final Function confirmEditingEvent;
  final Function copyEvent;
  final Function editEvent;
  final Function isEditing;
  const EventSelectedAppBar({
    Key? key,
    required this.eventsList,
    required this.selectedIndex,
    required this.amountSelectedEvents,
    required this.countSelectedEvents,
    required this.removeEvent,
    required this.confirmEditingEvent,
    required this.copyEvent,
    required this.editEvent,
    required this.isEditing,
  }) : super(key: key);

  @override
  _EventSelectedAppBarState createState() => _EventSelectedAppBarState();
}

class _EventSelectedAppBarState extends State<EventSelectedAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          setState(() {
            for (var item in widget.eventsList) {
              item.isSelected = false;
              item.isEditing = false;
            }
            widget.countSelectedEvents();
          });
        },
        icon: iconCancel,
      ),
      title: Text(
        '$widget.amountSelectedEvents',
        textAlign: TextAlign.left,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      actions: [
        widget.isEditing()
            ? _eventEditingAppBarOptions
            : _eventsNotEditingAppBarOptions
      ],
    );
  }

  Row get _eventsNotEditingAppBarOptions {
    return Row(
      children: [
        widget.amountSelectedEvents == 1
            ? IconButton(
                onPressed: widget.editEvent(),
                icon: iconEdit,
              )
            : Container(),
        IconButton(
          onPressed: widget.copyEvent(),
          icon: iconCopy,
        ),
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (var context) => _deleteAlertDilog,
            );
          },
          icon: iconDelete,
        ),
      ],
    );
  }

  AlertDialog get _deleteAlertDilog {
    return AlertDialog(
      title: const Text('Deleting events'),
      content: Text(
        'Are you sure you want to delete ${widget.amountSelectedEvents.toString()} selected events?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: widget.removeEvent(),
          child: const Text('OK'),
        ),
      ],
    );
  }

  Row get _eventEditingAppBarOptions {
    return Row(
      children: [
        IconButton(
          onPressed: () => widget.confirmEditingEvent(widget.selectedIndex),
          icon: iconCheck,
        )
      ],
    );
  }
}
