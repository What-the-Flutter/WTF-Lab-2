import 'package:flutter/material.dart';

import '../../models/page.dart';
import '../../models/pages_actions.dart';
import '../../styles.dart';

class DeleteConfirmationBottomSheet extends StatelessWidget {
  final List<PageInfo> pagesList;
  final int index;
  DeleteConfirmationBottomSheet({
    Key? key,
    required this.pagesList,
    required this.index,
  }) : super(key: key);

  final List<PageAction> _actions = [
    PageAction(
      'Delete',
      const Icon(
        Icons.delete,
        color: Colors.deepOrange,
      ),
    ),
    PageAction(
      'Cancel',
      const Icon(
        Icons.cancel,
        color: Colors.blue,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    void _deletePage() {
      pagesList.removeAt(index);
      Navigator.pop(context, pagesList);
    }

    return Container(
      height: 230,
      color: Theme.of(context).primaryColor,
      padding: const EdgeInsets.only(
        left: 20,
        top: 20,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Delete page "${pagesList[index].title}" ?',
            style: categoryTitleStyle,
          ),
          Container(
            padding: const EdgeInsets.only(top: 10),
            child: const Text(
              'Are you sure you want to delete this page? All events will be'
              'permanently deleted',
              style: categorySubtitleStyle,
            ),
          ),
          ListTile(
            leading: _actions[0].getIcon,
            title: Text(
              _actions[0].getTitle,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            onTap: _deletePage,
          ),
          ListTile(
            leading: _actions[1].getIcon,
            title: Text(
              _actions[1].getTitle,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
