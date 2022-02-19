import 'package:flutter/material.dart';

import '../../../entities/event.dart';
import 'bottom_text_field.dart';
import 'delete_events_button.dart';
import 'events_list.dart';
import 'page_introduction.dart';

class EventsScreenBody extends StatefulWidget {
  final bool isFavoriteShown;
  final String groupName;
  EventsScreenBody({
    Key? key,
    required this.isFavoriteShown,
    required this.groupName,
  }) : super(key: key);

  @override
  State<EventsScreenBody> createState() => _EventsScreenBodyState();
}

class _EventsScreenBodyState extends State<EventsScreenBody> {
  final List<Event> _events = <Event>[];
  final _editingText = '';

  void onEventSelected(Event event) {
    setState(() {
      event.isSelected = !event.isSelected;
    });
  }

  void addToEventList({
    required TextEditingController controller,
    required bool isRight,
  }) {
    final text = controller.text;
    if (text.isEmpty) return;
    setState(() {
      _events.add(Event(
        content: text,
        isRight: isRight,
        eventDate: DateTime.now(),
      ));
    });
  }

  void deleteEvents(int amountOfEvents) {
    setState(() {
      _events.removeWhere((element) => element.isSelected == true);
    });
  }

  @override
  Widget build(BuildContext context) {
    var favoriteEvents =
        _events.where((element) => element.isFavorite == true).toList();
    var selectedEvents =
        _events.where((element) => element.isSelected == true).toList();
    final controller = TextEditingController();
    return Column(
      children: [
        if (_events.isEmpty) PageIntroduction(groupName: widget.groupName),
        if (selectedEvents.isNotEmpty)
          DeleteEventsButton(
            deleteEvents: deleteEvents,
            amountOfEvents: selectedEvents.length,
          ),
        EventsList(
          events: widget.isFavoriteShown ? favoriteEvents : _events,
          textController: controller,
          onEventSelected: onEventSelected,
        ),
        BottomTextField(
          controller: controller,
          addToEventList: addToEventList,
        ),
      ],
    );
  }
}


