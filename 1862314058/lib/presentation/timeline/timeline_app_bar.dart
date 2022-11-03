import 'package:flutter/material.dart';

class TimelineAppBar extends StatelessWidget {
  const TimelineAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: const Text('Timeline'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: const Icon(
                Icons.search,
              ),
              onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {},
          ),
        ]);
  }
}
