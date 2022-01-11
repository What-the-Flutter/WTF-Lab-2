import 'package:flutter/material.dart';

import '../../models/page.dart';
import '../../styles.dart';

class PageListTile extends StatelessWidget {
  final Function onTap;
  final int index;
  final Function toggleSelection;
  final List<PageInfo> pagesList;

  const PageListTile({
    Key? key,
    required this.onTap,
    required this.index,
    required this.toggleSelection,
    required this.pagesList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onTap(index),
      onLongPress: () => toggleSelection(index),
      contentPadding: const EdgeInsets.only(left: 26),
      trailing: pagesList[index].eventList.isNotEmpty
          ? Container(
              child: Text(
                '${pagesList[index].eventList.last.date.hour}:'
                '${pagesList[index].eventList.last.date.minute}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              padding: const EdgeInsets.only(right: 14),
            )
          : const Text(''),
      title: Text(
        pagesList[index].title,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      leading: CircleAvatar(
        child: pagesList[index].icon,
        radius: 28,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Theme.of(context).primaryColor,
      ),
      subtitle: pagesList[index].eventList.isNotEmpty
          ? Text(
              pagesList[index].eventList.last.content,
              style: categorySubtitleStyle,
              maxLines: 2,
            )
          : Text(
              pagesList[index].subtitle,
              style: categorySubtitleStyle,
            ),
    );
  }
}
