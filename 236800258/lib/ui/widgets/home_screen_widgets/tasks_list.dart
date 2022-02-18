import 'package:flutter/material.dart';

import '../../../entities/task.dart';
import '../../../utils/constants/colors.dart';
import '../../navigation/app_navigation.dart';

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
            RouteNames.messagesScreen,
            arguments: itemName,
          );
        },
      );
    },
  );
}

class TasksList extends StatelessWidget {
  TasksList({Key? key}) : super(key: key);

  final List<Task> _tasks = [
    Task(icon: const Icon(Icons.airplane_ticket), title: 'Travel'),
    Task(icon: const Icon(Icons.home), title: 'Family'),
    Task(icon: const Icon(Icons.sports_football), title: 'Sports'),
    Task(icon: const Icon(Icons.ac_unit), title: 'Snowflake'),
    Task(icon: const Icon(Icons.airplane_ticket), title: 'Travel'),
    Task(icon: const Icon(Icons.home), title: 'Family'),
    Task(icon: const Icon(Icons.sports_football), title: 'Sports'),
    Task(icon: const Icon(Icons.ac_unit), title: 'Snowflake'),
    Task(icon: const Icon(Icons.airplane_ticket), title: 'Travel'),
    Task(icon: const Icon(Icons.home), title: 'Family'),
    Task(icon: const Icon(Icons.sports_football), title: 'Sports'),
    Task(icon: const Icon(Icons.ac_unit), title: 'Snowflake'),
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        itemCount: _tasks.length,
        itemBuilder: (context, i) {
          return _createListItem(
            itemIcon: _tasks[i].icon,
            itemName: _tasks[i].title,
            context: context,
          );
        },
        separatorBuilder: (context, i) {
          return const SizedBox(height: 8);
        },
      ),
    );
  }
}
