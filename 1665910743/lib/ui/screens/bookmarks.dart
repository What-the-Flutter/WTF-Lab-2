import 'package:flutter/material.dart';

import '/models/event.dart';
import '../../constants.dart';
import '../widgets/event_tile.dart';

class BookmarkEvents extends StatelessWidget {
  final List<Event> list;

  const BookmarkEvents({
    Key? key,
    required this.list,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
      ),
      body: Padding(
        padding: kListViewPadding,
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            if (list[index].favorite == true) {
              return Align(
                alignment: Alignment.bottomLeft,
                child: EventTile(
                  isSelected: list[index].isSelected,
                  title: list[index].title,
                  date: list[index].date,
                  favorite: list[index].favorite,
                  image: list[index].image,
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
