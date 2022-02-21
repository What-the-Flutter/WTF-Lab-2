import 'package:flutter/material.dart';

import '../../../entities/group.dart';
import 'create_list_item.dart';

class GroupsList extends StatefulWidget {
  final Group? newGroup;
  final Group? editedGroup;
  GroupsList({Key? key, this.newGroup, this.editedGroup}) : super(key: key);

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
    if (widget.editedGroup != null) {
      _groups[widget.editedGroup!.editingIndex!] =
          widget.editedGroup!.copyWith(editingIndex: null);
    }
  }

  final List<Group> _groups = [
    Group(icon: const Icon(Icons.airplane_ticket), title: 'Travel'),
    Group(icon: const Icon(Icons.home), title: 'Family'),
    Group(icon: const Icon(Icons.sports_football), title: 'Sports'),
    Group(icon: const Icon(Icons.ac_unit), title: 'Snowflake'),
  ];

  void onDeleteItem(int index) {
    _groups.removeAt(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        itemCount: _groups.length,
        itemBuilder: (context, i) {
          return createListItem(
            currentGroup: _groups[i],
            context: context,
            onDeleteItem: onDeleteItem,
            index: i,
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
