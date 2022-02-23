import 'package:flutter/material.dart';

import '../../../navigation/route_names.dart';

class NewGroupAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isEditing;

  const NewGroupAppBar({
    Key? key,
    required this.isEditing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title:
          isEditing ? const Text('Edit Group') : const Text('Create new group'),
      centerTitle: true,
      leading: IconButton(
        onPressed: () =>
            Navigator.of(context).popAndPushNamed(RouteNames.mainScreen),
        icon: const Icon(Icons.arrow_back),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
