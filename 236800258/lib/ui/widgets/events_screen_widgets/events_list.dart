import 'package:flutter/material.dart';

import '../../../entities/event.dart';
import 'list_item.dart';

class EventsList extends StatelessWidget {
  final List<Event> events;
  final TextEditingController textController;
  final Function onEventSelected;

  EventsList({
    Key? key,
    required this.textController,
    required this.events,
    required this.onEventSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        reverse: true,
        itemCount: events.length,
        itemBuilder: (context, index) {
          final _currentEvent = events.reversed.toList()[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            child: Align(
              alignment: (_currentEvent.isRight
                  ? Alignment.centerRight
                  : Alignment.centerLeft),
              child: ListItem(
                event: _currentEvent,
                textController: textController,
                onEventSelected: onEventSelected,
              ),
            ),
          );
        },
      ),
    );
  }
}
