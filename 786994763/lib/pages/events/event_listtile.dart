import 'package:flutter/material.dart';

import '../../models/event.dart';
import '../../styles.dart';
import 'const_widgets.dart';

class EventListTile extends StatelessWidget {
  final int index;
  final Function getTimeFromDate;
  final List<Event> eventList;
  final Function onTap;
  final Function countSelectedEvents;
  final Function setState;
  static const _accentColor = Color(0xff86BB8B);
  final int selectedIndex;

  const EventListTile({
    Key? key,
    required this.index,
    required this.getTimeFromDate,
    required this.eventList,
    required this.onTap,
    required this.countSelectedEvents,
    required this.setState,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _eventModificatorsLayout(int index) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              getTimeFromDate(
                eventList[index].date,
              ),
              style: eventTimeStyle,
            ),
          ),
          eventList[index].isFavourite ? eventFavourite : emptyContainer,
          eventList[index].isEdited ? eventEdited : emptyContainer,
        ],
      );
    }

    Widget _eventLayout(int index) {
      return ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 106,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: eventList[index].isSelected
                ? const Color(0xff687dc5)
                : const Color(0xff859ef7),
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.only(
            top: 10,
            right: 15,
            left: 15,
            bottom: 24,
          ),
          child: Text(
            eventList[index].content,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        onTap(index);
        setState(countSelectedEvents);
      },
      onLongPress: () {
        setState(() {
          eventList[index].isSelected = true;
          countSelectedEvents();
        });
      },
      child: Container(
        padding: const EdgeInsets.only(
          left: 14,
          right: 46,
          top: 6,
          bottom: 6,
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              _eventLayout(index),
              _eventModificatorsLayout(index),
            ],
          ),
        ),
      ),
    );
  }
}
