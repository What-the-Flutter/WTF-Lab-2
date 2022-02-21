import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../entities/group.dart';

class InfoDialog extends StatelessWidget {
  final Group group;

  const InfoDialog({
    Key? key,
    required this.group,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        contentPadding: const EdgeInsets.all(10),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            group.groupIcon,
            const SizedBox(width: 10),
            Text(group.title),
          ],
        ),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Created at: '),
              Text(DateFormat.yMMMMEEEEd().format(group.createdAt)),
              const SizedBox(height: 10),
              const Text('Edited at: '),
              Text(DateFormat.yMMMMEEEEd().format(group.editedAt)),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Ok'),
          )
        ]);
  }
}
