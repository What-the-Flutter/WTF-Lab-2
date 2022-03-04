import 'dart:ui';

import 'package:flutter/material.dart';

import 'task.dart';

class InfoTask extends StatelessWidget {
  final Task task;

  InfoTask({Key? key, required this.task}) : super(key: key);

  String _getTimeAndDataFormat(DateTime date) {
    return '${date.day}.${date.month}.${date.year} - '
        '${date.hour}.${date.minute}';
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
      child: AlertDialog(
        title: Row(
          children: [
            task.leadingIcon,
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Text(task.header),
            ),
          ],
        ),
        content: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Creation: ${_getTimeAndDataFormat(task.dateTimeCreation)}',
              ),
              Text(
                'Last modify: ${task.isEdited
                    ? _getTimeAndDataFormat(task.dataTimeLastUpdate)
                    : 'Not modified'}',
              )
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
