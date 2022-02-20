import 'package:flutter/material.dart';

import '../../../entities/group.dart';
import '../../../navigation/route_names.dart';
import '../../../utils/constants/colors.dart';

class GroupsList extends StatefulWidget {
  final Group? newGroup;

  GroupsList({Key? key, this.newGroup}) : super(key: key);

  @override
  State<GroupsList> createState() => _GroupsListState();
}

class _GroupsListState extends State<GroupsList> {
  @override
  void initState() {
    super.initState();
    if (widget.newGroup != null) {
      _groups.add(
        Group(icon: widget.newGroup!.icon, title: widget.newGroup!.title),
      );
    }
  }

  final List<Group> _groups = [
    Group(icon: const Icon(Icons.airplane_ticket), title: 'Travel'),
    Group(icon: const Icon(Icons.home), title: 'Family'),
    Group(icon: const Icon(Icons.sports_football), title: 'Sports'),
    Group(icon: const Icon(Icons.ac_unit), title: 'Snowflake'),
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        itemCount: _groups.length,
        itemBuilder: (context, i) {
          return _createListItem(
            itemIcon: _groups[i].icon,
            itemName: _groups[i].title,
            context: context,
          );
        },
        separatorBuilder: (context, i) {
          return Theme.of(context).brightness == Brightness.dark
              ? const Divider(height: 1, thickness: 0.8)
              : const SizedBox(height: 8);
        },
      ),
    );
  }
}

class _OnHoverListTile extends StatefulWidget {
  final Widget Function(bool isHovered) builder;
  _OnHoverListTile({Key? key, required this.builder}) : super(key: key);

  @override
  State<_OnHoverListTile> createState() => _OnHoverListTileState();
}

class _OnHoverListTileState extends State<_OnHoverListTile> {
  bool isHovered = false;

  void onEntered(bool isHovered) {
    setState(() {
      this.isHovered = isHovered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => onEntered(true),
      onExit: (event) => onEntered(false),
      child: widget.builder(isHovered),
    );
  }
}

Widget _createListItem({
  required Icon itemIcon,
  required String itemName,
  required BuildContext context,
}) {
  return _OnHoverListTile(
    builder: (isHovered) {
      final theme = Theme.of(context).listTileTheme;
      return ListTile(
        tileColor: isHovered == true
            ? CustomColors.onListTileHovered
            : theme.tileColor,
        leading: CircleAvatar(
          child: itemIcon,
        ),
        title: Text(itemName),
        subtitle: const Text('No events. Click to create one.'),
        onTap: () {
          Navigator.of(context).pushNamed(
            RouteNames.eventsScreen,
            arguments: itemName,
          );
        },
      );
    },
  );
}
