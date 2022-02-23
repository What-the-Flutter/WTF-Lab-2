import 'package:flutter/material.dart';

import '../../../entities/bottom_sheet_content.dart';
import '../../../entities/group.dart';

class BottomSheetItem extends StatelessWidget {
  final Icon icon;
  final String title;
  final void Function() onTap;

  BottomSheetItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: ListTile(
        onTap: onTap,
        leading: icon,
        title: Text(title),
      ),
    );
  }
}

class HomeScreenBottomSheet extends StatelessWidget {
  final void Function(Group) onInfoPressed;
  final void Function(Group) onPinPressed;
  final void Function() onArchivePressed;
  final void Function(Group, int) onEditPressed;
  final void Function(int) onDeletePressed;
  final Group currentGroup;
  final int currentIndex;

  HomeScreenBottomSheet({
    Key? key,
    required this.onInfoPressed,
    required this.onPinPressed,
    required this.onArchivePressed,
    required this.onEditPressed,
    required this.onDeletePressed,
    required this.currentGroup,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _contentList = <BottomSheetContent>[
      BottomSheetContent(
        icon: const Icon(Icons.info),
        title: 'Info',
        onTap: () => onInfoPressed(currentGroup),
      ),
      BottomSheetContent(
        icon: const Icon(Icons.push_pin),
        title: 'Pin/Unpin',
        onTap: () => onPinPressed(currentGroup),
      ),
      BottomSheetContent(
        icon: const Icon(Icons.archive),
        title: 'Archive',
        onTap: onArchivePressed,
      ),
      BottomSheetContent(
        icon: const Icon(Icons.edit),
        title: 'Edit',
        onTap: () => onEditPressed(currentGroup, currentIndex),
      ),
      BottomSheetContent(
        icon: const Icon(Icons.delete),
        title: 'Delete',
        onTap: () => onDeletePressed(currentIndex),
      ),
    ];

    return ListView.builder(
      shrinkWrap: true,
      itemCount: _contentList.length,
      itemBuilder: (context, index) {
        final current = _contentList[index];
        return BottomSheetItem(
          icon: current.icon,
          title: current.title,
          onTap: current.onTap,
        );
      },
    );
  }
}
