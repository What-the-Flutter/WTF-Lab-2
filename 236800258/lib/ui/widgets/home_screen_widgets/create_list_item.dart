import 'package:flutter/material.dart';

import '../../../entities/group.dart';
import '../../../navigation/route_names.dart';
import '../../../utils/constants/colors.dart';
import 'home_screen_bottom_sheet.dart';

Widget createListItem({
  required Group currentGroup,
  required int currentIndex,
  required BuildContext context,
  required void Function(Group) onInfoPressed,
  required void Function(Group) onPinPressed,
  required void Function() onArchivePressed,
  required void Function(Group, int) onEditPressed,
  required void Function(int) onDeletePressed,
}) {
  return _OnHoverListTile(
    builder: (isHovered) {
      final theme = Theme.of(context).listTileTheme;
      return ListTile(
        onLongPress: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return HomeScreenBottomSheet(
                currentIndex: currentIndex,
                currentGroup: currentGroup,
                onInfoPressed: onInfoPressed,
                onPinPressed: onPinPressed,
                onArchivePressed: onArchivePressed,
                onEditPressed: onEditPressed,
                onDeletePressed: onDeletePressed,
              );
            },
          );
        },
        tileColor: isHovered == true
            ? CustomColors.onListTileHovered
            : theme.tileColor,
        leading: CircleAvatar(
          child: currentGroup.groupIcon,
        ),
        trailing:
            currentGroup.isPinned ? const Icon(Icons.push_pin_rounded) : null,
        title: Text(currentGroup.title),
        subtitle: const Text('No events. Click to create one.'),
        onTap: () => Navigator.of(context).pushNamed(
          RouteNames.eventsScreen,
          arguments: currentGroup.title,
        ),
      );
    },
  );
}

class _OnHoverListTile extends StatefulWidget {
  final Widget Function(bool isHovered) builder;

  _OnHoverListTile({
    Key? key,
    required this.builder,
  }) : super(key: key);

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
