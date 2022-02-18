import 'package:flutter/material.dart';

import '../../../entities/event.dart';
import 'bottom_text_field.dart';
import 'delete_events_button.dart';
import 'events_list.dart';

class EventsScreenBody extends StatefulWidget {
  final bool isFavoriteShown;
  final String taskName;
  EventsScreenBody({
    Key? key,
    required this.isFavoriteShown,
    required this.taskName,
  }) : super(key: key);

  @override
  State<EventsScreenBody> createState() => _EventsScreenBodyState();
}

class _EventsScreenBodyState extends State<EventsScreenBody> {
  List<Event> events = <Event>[];
  String editingText = '';

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
      events.add(Event(
        content: text,
        isRight: isRight,
        eventDate: DateTime.now(),
      ));
    });
  }

  void deleteEvents(int amountOfEvents) {
    setState(() {
      events.removeWhere((element) => element.isSelected == true);
    });
  }

  @override
  Widget build(BuildContext context) {
    var favoriteEvents =
        events.where((element) => element.isFavorite == true).toList();
    var selectedEvents =
        events.where((element) => element.isSelected == true).toList();
    final controller = TextEditingController();
    return Column(
      children: [
        if (events.isEmpty) PageIntroduction(taskName: widget.taskName),
        if (selectedEvents.isNotEmpty)
          DeleteEventsButton(
            deleteEvents: deleteEvents,
            amountOfEvents: selectedEvents.length,
          ),
        EventList(
          events: widget.isFavoriteShown ? favoriteEvents : events,
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


class PageIntroduction extends StatelessWidget {
  final String taskName;

  const PageIntroduction({Key? key, required this.taskName}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.inversePrimary.withAlpha(120),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'This is the page where you can track everything about "$taskName".',
            style:
                Theme.of(context).textTheme.headline5?.copyWith(fontSize: 22),
          ),
          const SizedBox(height: 10),
          Text(
            'Add your first event to "$taskName" page by entering some text in the text box below and hitting the send button. Long tap the send button to align the event in the opposite direction. Tap on the favorite icon on the top right corner to show the favorite events only.',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ],
      ),
    );
  }
}
