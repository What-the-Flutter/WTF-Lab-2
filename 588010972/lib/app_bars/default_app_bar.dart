import 'package:flutter/material.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Function() backToPreviousScreen;
  final Function() screenBookMark;

  const DefaultAppBar({
    Key? key,
    required this.title,
    required this.backToPreviousScreen,
    required this.screenBookMark,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(
          Icons.west,
        ),
        onPressed: backToPreviousScreen,
      ),
      title: Align(
        alignment: Alignment.center,
        child: Text('$title'),
      ),
      actions: [
        const IconButton(
          icon: Icon(
            Icons.search,
          ),
          onPressed: null,
        ),
        IconButton(
          icon: const Icon(
            Icons.bookmark_border,
          ),
          onPressed: screenBookMark,
        ),
      ],
    );
  }
}
