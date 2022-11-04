import 'package:flutter/material.dart';

class DailyAppBar extends StatelessWidget {
  const DailyAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Daily'),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.playlist_add_outlined),
          onPressed: () {},
        ),
      ],
    );
  }
}
