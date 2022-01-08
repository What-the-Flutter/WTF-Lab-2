import 'package:flutter/material.dart';

import '../../models/pages_actions.dart';
import '../../styles.dart';

class CustomBottomSheet extends StatelessWidget {
  CustomBottomSheet({Key? key}) : super(key: key);

  final List<PageAction> _actions = [];

  @override
  Widget build(BuildContext context) {
    _actions.add(PageAction(
        'Info',
        const Icon(
          Icons.info,
          color: Colors.green,
          size: 30,
        )));
    _actions.add(PageAction(
        'Pin/Unpin Page',
        const Icon(
          Icons.attach_file_sharp,
          color: Colors.blueGrey,
          size: 30,
        )));
    _actions.add(PageAction(
        'Archive Page',
        const Icon(
          Icons.archive,
          color: Colors.orange,
          size: 30,
        )));
    _actions.add(PageAction(
        'Edit Page',
        const Icon(
          Icons.edit,
          color: Colors.blue,
          size: 30,
        )));
    _actions.add(PageAction(
        'Delete Page',
        const Icon(
          Icons.delete,
          color: Colors.deepOrange,
          size: 30,
        )));
    return Container(
      margin: const EdgeInsets.only(
        left: 20,
        right: 20,
      ),
      height: 350,
      color: Colors.white,
      child: ListView.separated(
        itemBuilder: (
          context,
          index,
        ) {
          return ListTile(
            title: Text(
              _actions[index].title,
              style: categorySubtitleStyle,
            ),
            leading: _actions[index].icon,
          );
        },
        separatorBuilder: (
          context,
          index,
        ) =>
            const Divider(
          thickness: 0,
        ),
        itemCount: _actions.length,
      ),
    );
  }
}
