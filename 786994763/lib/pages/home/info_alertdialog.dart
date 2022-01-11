import 'package:flutter/material.dart';

import '../../models/page.dart';

class InfoPageAlertDialog extends StatelessWidget {
  final int index;
  final List<PageInfo> pagesList;
  const InfoPageAlertDialog({
    Key? key,
    required this.index,
    required this.pagesList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: ListTile(
        leading: pagesList[index].icon,
        title: Text(
          pagesList[index].title,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
      content: Container(
        height: 140,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Created',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${pagesList[index].createdTime.year}/'
                  '${pagesList[index].createdTime.month}/'
                  '${pagesList[index].createdTime.day} at '
                  '${pagesList[index].createdTime.hour}:'
                  '${pagesList[index].createdTime.minute}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                  top: 34,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Last Event',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${pagesList[index].lastEditTime.year}/'
                  '${pagesList[index].lastEditTime.month}/'
                  '${pagesList[index].lastEditTime.day} at '
                  '${pagesList[index].lastEditTime.hour}:'
                  '${pagesList[index].lastEditTime.minute}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('OK'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
