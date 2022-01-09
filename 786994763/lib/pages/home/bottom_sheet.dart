import 'package:flutter/material.dart';

import '../../models/page.dart';
import '../../models/pages_actions.dart';
import '../../styles.dart';
import '../creating_new_page/add_page_route.dart';
import 'info_alertdialog.dart';

class ScreenArguments {
  late int index;
  late List<PageInfo> pagesList;
  late bool isEditing;

  ScreenArguments(
    this.index,
    this.pagesList,
    this.isEditing,
  );
}

class CustomBottomSheet extends StatelessWidget {
  final BuildContext context;
  final List<PageInfo> pagesList;
  final int index;
  CustomBottomSheet({
    Key? key,
    required this.context,
    required this.pagesList,
    required this.index,
  }) : super(key: key);

  final List<PageAction> _actions = [];

  @override
  Widget build(BuildContext context) {
    _actions.add(
      PageAction(
        'Info',
        const Icon(
          Icons.info,
          color: Colors.green,
          size: 30,
        ),
      ),
    );
    _actions.add(
      PageAction(
        'Pin/Unpin Page',
        const Icon(
          Icons.attach_file_sharp,
          color: Colors.blueGrey,
          size: 30,
        ),
      ),
    );
    _actions.add(
      PageAction(
        'Edit Page',
        const Icon(
          Icons.edit,
          color: Colors.blue,
          size: 30,
        ),
      ),
    );
    _actions.add(
      PageAction(
        'Delete Page',
        const Icon(
          Icons.delete,
          color: Colors.deepOrange,
          size: 30,
        ),
      ),
    );
    return Container(
      height: 250,
      margin: const EdgeInsets.only(
        left: 10,
        top: 10,
      ),
      child: Column(
        children: [
          ListTile(
            leading: _actions[0].icon,
            title: Text(
              _actions[0].title,
              style: categorySubtitleStyle,
            ),
            onTap: _showPageInfo,
          ),
          ListTile(
            leading: _actions[1].icon,
            title: Text(
              _actions[1].title,
              style: categorySubtitleStyle,
            ),
          ),
          ListTile(
            leading: _actions[2].icon,
            title: Text(
              _actions[2].title,
              style: categorySubtitleStyle,
            ),
            onTap: _editPageInfo,
          ),
          ListTile(
            leading: _actions[3].icon,
            title: Text(
              _actions[3].title,
              style: categorySubtitleStyle,
            ),
          ),
        ],
      ),
    );
  }

  void _showPageInfo() {
    showDialog(
      context: context,
      builder: (var context) =>
          InfoPageAlertDialog(index: index, pagesList: pagesList),
    );
  }

  void _editPageInfo() async {
    await Navigator.pushNamed(context, PageInput.routeName,
        arguments: ScreenArguments(index, pagesList, true));
    Navigator.pop(context);
  }
}
