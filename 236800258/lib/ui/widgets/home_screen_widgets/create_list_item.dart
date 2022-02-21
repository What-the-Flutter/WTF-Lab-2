import 'package:flutter/material.dart';

import '../../../entities/group.dart';
import '../../../navigation/route_names.dart';
import '../../../utils/constants/colors.dart';

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

Widget _createBottomSheetItem({
  required Icon icon,
  required String title,
  required void Function() onTap,
}) {
  return Padding(
    padding: const EdgeInsets.all(5),
    child: ListTile(
      onTap: onTap,
      leading: icon,
      title: Text(title),
    ),
  );
}

Widget createListItem({
  required Group currentGroup,
  required BuildContext context,
  required Function onDeleteItem,
  required int index,
}) {
  return _OnHoverListTile(
    builder: (isHovered) {
      final theme = Theme.of(context).listTileTheme;
      return ListTile(
        onLongPress: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _createBottomSheetItem(
                    icon: const Icon(Icons.info),
                    title: 'Info',
                    onTap: () {},
                  ),
                  _createBottomSheetItem(
                    icon: const Icon(Icons.push_pin),
                    title: 'Pin',
                    onTap: () {},
                  ),
                  _createBottomSheetItem(
                    icon: const Icon(Icons.archive),
                    title: 'Archive',
                    onTap: () {},
                  ),
                  _createBottomSheetItem(
                    icon: const Icon(Icons.edit),
                    title: 'Edit',
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        RouteNames.createNewGroupScreen,
                        arguments: currentGroup.copyWith(editingIndex: index),
                      );
                    },
                  ),
                  _createBottomSheetItem(
                    icon: const Icon(Icons.delete),
                    title: 'Delete',
                    onTap: () {
                      onDeleteItem(index);
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
        },
        tileColor: isHovered == true
            ? CustomColors.onListTileHovered
            : theme.tileColor,
        leading: CircleAvatar(
          child: currentGroup.icon,
        ),
        title: Text(currentGroup.title),
        subtitle: const Text('No events. Click to create one.'),
        onTap: () {
          Navigator.of(context).pushNamed(
            RouteNames.eventsScreen,
            arguments: currentGroup.title,
          );
        },
      );
    },
  );
}
