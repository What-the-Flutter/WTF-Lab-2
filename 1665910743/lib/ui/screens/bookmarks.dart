import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../constants.dart';
import '../../models/event.dart';
import '../widgets/event_tile.dart';
import '../widgets/event_tile_actions.dart';

class BookmarkEvents extends StatelessWidget {
  final _user = FirebaseAuth.instance.currentUser!.uid;
  BookmarkEvents({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
      ),
      body: Padding(
        padding: kListViewPadding,
        child: FirebaseAnimatedList(
            query: FirebaseDatabase.instance.ref().child(_user).child('events'),
            itemBuilder: (context, snapshot, animation, x) {
              final event = Event.fromMap(
                Map.from(snapshot.value as Map),
              );

              if (event.favorite == true) {
                return Slidable(
                  startActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      EditAction(event: event, eventKey: snapshot.key!),
                      RemoveAction(eventKey: snapshot.key!),
                      MoveAction(eventKey: snapshot.key!),
                    ],
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          EventTile(
                              iconCode: event.iconCode,
                              isSelected: event.isSelected == 0 ? false : true,
                              title: event.title,
                              date: event.date,
                              favorite: event.favorite == 0 ? false : true,
                              image: null),
                          Text(' from ${event.categoryTitle}'),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return const SizedBox();
              }
            }),
      ),
    );
  }
}
