import 'package:flutter/material.dart';

import '../../models/page.dart';
import '../../models/pages_actions.dart';
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

  ScreenArguments.removePage(
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
            leading: _actions[0].getIcon,
            title: Text(
              _actions[0].getTitle,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            onTap: _showPageInfo,
          ),
          ListTile(
            leading: _actions[1].getIcon,
            title: Text(
              _actions[1].getTitle,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          ListTile(
            leading: _actions[2].getIcon,
            title: Text(
              _actions[2].getTitle,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            onTap: _editPageInfo,
          ),
          ListTile(
            leading: _actions[3].getIcon,
            title: Text(
              _actions[3].getTitle,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            onTap: _removePage,
          ),
        ],
      ),
    );
  }

  void _showPageInfo() {
    showDialog(
      context: context,
      builder: (var context) => InfoPageAlertDialog(
        index: index,
        pagesList: pagesList,
      ),
    );
  }

  void _editPageInfo() async {
    await Navigator.pushNamed(
      context,
      PageInput.routeName,
      arguments: ScreenArguments(
        index,
        pagesList,
        true,
      ),
    );
    Navigator.pop(context);
  }

  void _removePage() {
    Navigator.pop(
      context,
      ScreenArguments.removePage(
        pagesList,
        false,
      ),
    );
  }
}
