import 'package:flutter/material.dart';

import '../../models/page.dart';
import '../../styles.dart';

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
          style: categoryTitleStyle,
        ),
      ),
      content: Container(
        height: 120,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
          ),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Created',
                  style: categorySubtitleStyle,
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
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                  top: 34,
                ),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Last Event',
                    style: categorySubtitleStyle,
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
                ),
              )
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
