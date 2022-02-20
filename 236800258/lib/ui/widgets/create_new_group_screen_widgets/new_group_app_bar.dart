import 'package:flutter/material.dart';

import '../../../navigation/route_names.dart';

class NewGroupAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NewGroupAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Create new group'),
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).popAndPushNamed(
            RouteNames.mainScreen,
          );
        },
        icon: const Icon(Icons.arrow_back),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
