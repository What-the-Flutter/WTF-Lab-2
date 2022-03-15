import 'package:flutter/material.dart';

import '../models/event.dart';
import '../widgets/event_tile.dart';

class BookmarkEvents extends StatelessWidget {
  final List<Event> list;
  BookmarkEvents({
    Key? key,
    required this.list,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
      ),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          if (list[index].favorite == true) {
            return EventTile(
              title: list[index].title,
              date: list[index].date,
              favorite: list[index].favorite,
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
