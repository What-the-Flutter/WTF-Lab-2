import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../utils/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const _BotChatButton(),
          Container(height: 10, color: Colors.white),
          _TasksList(),
        ],
      ),
    );
  }
}

class _BotChatButton extends StatelessWidget {
  const _BotChatButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16),
      color: Colors.white,
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          backgroundColor: CustomColors.botChatButtonColor,
          minimumSize: const Size(double.infinity, 65),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FaIcon(FontAwesomeIcons.robot),
            const SizedBox(width: 20),
            const Text(
              'Questionnaire Bot',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _Task {
  final Icon icon;
  final String title;
  _Task({
    required this.icon,
    required this.title,
  });
}

class _OnHoverListTile extends StatefulWidget {
  _OnHoverListTile({Key? key, required this.builder}) : super(key: key);
  final Widget Function(bool isHovered) builder;
  @override
  State<_OnHoverListTile> createState() => _OnHoverListTileState();
}

class _OnHoverListTileState extends State<_OnHoverListTile> {
  bool isHovered = false;

  void onEntered(bool isHovered) {
    setState(
      () {
        this.isHovered = isHovered;
      },
    );
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
  return _OnHoverListTile(builder: (isHovered) {
    final theme = Theme.of(context).listTileTheme;
    return ListTile(
      tileColor:
          isHovered == true ? CustomColors.onListTileHovered : theme.tileColor,
      leading: CircleAvatar(
        child: itemIcon,
      ),
      title: Text(itemName),
      subtitle: const Text('No events. Click to create one.'),
    );
  });
}

class _TasksList extends StatelessWidget {
  _TasksList({Key? key}) : super(key: key);

  final List<_Task> tasks = [
    _Task(icon: const Icon(Icons.airplane_ticket), title: 'Travel'),
    _Task(icon: const Icon(Icons.home), title: 'Family'),
    _Task(icon: const Icon(Icons.sports_football), title: 'Sports'),
    _Task(icon: const Icon(Icons.ac_unit), title: 'Snowflake'),
    _Task(icon: const Icon(Icons.airplane_ticket), title: 'Travel'),
    _Task(icon: const Icon(Icons.home), title: 'Family'),
    _Task(icon: const Icon(Icons.sports_football), title: 'Sports'),
    _Task(icon: const Icon(Icons.ac_unit), title: 'Snowflake'),
    _Task(icon: const Icon(Icons.airplane_ticket), title: 'Travel'),
    _Task(icon: const Icon(Icons.home), title: 'Family'),
    _Task(icon: const Icon(Icons.sports_football), title: 'Sports'),
    _Task(icon: const Icon(Icons.ac_unit), title: 'Snowflake'),
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        itemCount: tasks.length,
        itemBuilder: (context, i) {
          return _createListItem(
            itemIcon: tasks[i].icon,
            itemName: tasks[i].title,
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
