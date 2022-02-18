import 'package:flutter/material.dart';

class DeleteEventsButton extends StatelessWidget {
  final Function(int) deleteEvents;
  final int amountOfEvents;

  const DeleteEventsButton({
    Key? key,
    required this.deleteEvents,
    required this.amountOfEvents,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        deleteEvents(amountOfEvents);
      },
      child: Text(
        'Delete $amountOfEvents items(s)',
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
