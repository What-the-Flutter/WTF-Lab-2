import 'package:flutter/material.dart';
import 'data/event.dart';

class EventTile extends StatelessWidget {
  final int index;
  final List<Event> eventsList;
  final Function onTap;
  final Function onPressed;
  final Function getTime;

  const EventTile(
      {Key? key,
      required this.index,
      required this.eventsList,
      required this.onTap,
      required this.onPressed,
      required this.getTime,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _downLine() {
      return Row(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 15),
            child: Text(getTime(eventsList[index].datetime),),
          ),
          eventsList[index].inBookMarks
              ? const Icon(
                  Icons.bookmark_border,
                  color: Colors.grey,
                )
              : Container(
                  height: 24,
                ),
          eventsList[index].isEdited
              ? const Icon(
                  Icons.edit,
                  color: Colors.grey,
                )
              : Container(
                  height: 24,
                ),
        ],
      );
    }

    Widget _eventLine() {
      return ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 106,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: eventsList[index].isSelected
                ? Colors.green[500]
                : Colors.green[200],
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.only(
            top: 10,
            right: 15,
            left: 15,
            bottom: 24,
          ),
          child: Text(
            eventsList[index].content,
            style: const TextStyle(
              fontSize: 17,
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        onTap(index);
      },
      onLongPress: () {
        onPressed(index);
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
              _eventLine(),
              _downLine(),
            ],
          ),
        ),
      ),
    );
  }
}
