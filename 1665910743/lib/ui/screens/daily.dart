import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../cubit/category_cubit/category_list_cubit.dart';
import '../../cubit/category_cubit/category_list_state.dart';
import '../../models/event.dart';
import '../widgets/event_tile.dart';
import '../widgets/event_tile_actions.dart';

class Daily extends StatelessWidget {
  static const title = 'Daily';
  final _user = FirebaseAuth.instance.currentUser;

  Daily({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CategoryListCubit>().state;

    return Container(
      child: state.searchMode
          ? SearchResultList(state: state, uid: _user?.uid)
          : BodyList(uid: _user?.uid),
    );
  }
}

class BodyList extends StatelessWidget {
  final String? uid;

  BodyList({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FirebaseAnimatedList(
        query: FirebaseDatabase.instance.ref().child(uid!).child('events'),
        itemBuilder: (context, snapshot, animation, x) {
          final event = Event.fromMap(
            Map.from(snapshot.value as Map),
          );

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
        });
  }
}

class SearchResultList extends StatelessWidget {
  final CategoryListState state;
  final String? uid;
  const SearchResultList({Key? key, required this.state, this.uid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FirebaseAnimatedList(
        query: FirebaseDatabase.instance.ref().child(uid!).child('events'),
        itemBuilder: (context, snapshot, animation, x) {
          final event = Event.fromMap(
            Map.from(snapshot.value as Map),
          );

          if (event.title == state.searchResult) {
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
        });
  }
}
