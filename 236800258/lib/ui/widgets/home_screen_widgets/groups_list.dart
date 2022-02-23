import 'package:flutter/material.dart';

import '../../../entities/group.dart';
import '../../../navigation/route_names.dart';
import 'create_list_item.dart';
import 'info_dialog.dart';

class GroupsList extends StatefulWidget {
  final Group? newGroup;
  final Group? editedGroup;

  GroupsList({
    Key? key,
    this.newGroup,
    this.editedGroup,
  }) : super(key: key);

  @override
  State<GroupsList> createState() => _GroupsListState();
}

class _GroupsListState extends State<GroupsList> {
  final List<Group> _groups = [
    Group(
      groupIcon: const Icon(Icons.airplane_ticket),
      title: 'Travel',
      createdAt: DateTime.now(),
      editedAt: DateTime.now(),
    ),
    Group(
      groupIcon: const Icon(Icons.home),
      title: 'Family',
      createdAt: DateTime.now(),
      editedAt: DateTime.now(),
    ),
    Group(
      groupIcon: const Icon(Icons.sports_football),
      title: 'Sports',
      createdAt: DateTime.now(),
      editedAt: DateTime.now(),
    ),
    Group(
      groupIcon: const Icon(Icons.ac_unit),
      title: 'Snowflake',
      createdAt: DateTime.now(),
      editedAt: DateTime.now(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.newGroup != null) {
      var newGroup = widget.newGroup!;
      _groups.add(
        Group(
          groupIcon: newGroup.groupIcon,
          title: newGroup.title,
          createdAt: newGroup.createdAt,
          editedAt: newGroup.editedAt,
        ),
      );
    }
    if (widget.editedGroup != null) {
      var currentGroup = _groups[widget.editedGroup!.editingIndex!];
      var editedGroup = widget.editedGroup!;
      currentGroup.groupIcon = editedGroup.groupIcon;
      currentGroup.title = editedGroup.title;
      currentGroup.editedAt = editedGroup.editedAt;
    }
  }

  void onInfoPressed(Group group) {
    showDialog(
      context: context,
      builder: (context) {
        return InfoDialog(group: group);
      },
    );
  }

  void onPinPressed(Group group) {
    if (group.isPinned) {
      group.isPinned = false;
    } else {
      group.isPinned = true;
    }
    setState(() {});
    Navigator.pop(context);
  }

  void onEditPressed(Group group, int index) {
    Navigator.of(context).pushNamed(
      RouteNames.createNewGroupScreen,
      arguments: group.copyWith(editingIndex: index),
    );
  }

  void onArchivePressed() {
    Navigator.pop(context);
  }

  void onDeletePressed(int index) {
    _groups.removeAt(index);
    setState(() {});
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    _groups.sort((a, b) => a.compareTo(b));

    return Expanded(
      child: ListView.separated(
        itemCount: _groups.length,
        itemBuilder: (context, index) {
          return createListItem(
            currentGroup: _groups[index],
            currentIndex: index,
            context: context,
            onInfoPressed: onInfoPressed,
            onPinPressed: onPinPressed,
            onArchivePressed: onArchivePressed,
            onEditPressed: onEditPressed,
            onDeletePressed: onDeletePressed,
          );
        },
        separatorBuilder: (context, index) {
          return Theme.of(context).brightness == Brightness.dark
              ? const Divider(height: 1, thickness: 0.8)
              : const SizedBox(height: 8);
        },
      ),
    );
  }
}
