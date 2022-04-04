
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../cubit/category_cubit/category_list_cubit.dart';
import '../../cubit/category_cubit/category_list_state.dart';
import '../widgets/edit_chat_item_dialog.dart';
import '../widgets/event_tile.dart';
import '../widgets/move_event_tile.dart';

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
            : BodyList(uid: _user?.uid));
  }
}

class BodyList extends StatelessWidget {
  final String? uid;

  BodyList({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FirebaseAnimatedList(
        query: FirebaseDatabase.instance.ref().child(uid ?? '').child('events'),
        itemBuilder: (context, snapshot, animation, x) {
          final event = Map.from(snapshot.value as Map);

          return Slidable(
            startActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) => chatTileEditDialog(
                    isBookmarked: event['favorite'] == 0 ? false : true,
                    key: snapshot.key!,
                    title: event['title'],
                    context: context,
                  ),
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  foregroundColor: Theme.of(context).primaryColor,
                  icon: Icons.edit,
                ),
                SlidableAction(
                  onPressed: (context) => context
                      .read<CategoryListCubit>()
                      .removeEventInCategory(key: snapshot.key!),
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  foregroundColor: Theme.of(context).primaryColor,
                  icon: Icons.delete,
                ),
                SlidableAction(
                  autoClose: true,
                  onPressed: (context) {
                    moveTile(context: context, eventKey: snapshot.key!);
                  },
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  foregroundColor: Theme.of(context).primaryColor,
                  icon: Icons.move_down,
                ),
              ],
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: EventTile(
                    iconCode: event['icon'],
                    isSelected: event['isSelected'] == 0 ? false : true,
                    title: event['title'],
                    date: DateTime.parse(event['date']),
                    favorite: event['favorite'] == 0 ? false : true,
                    image: null),
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
        query: FirebaseDatabase.instance.ref().child(uid ?? '').child('events'),
        itemBuilder: (context, snapshot, animation, x) {
          final event = Map.from(snapshot.value as Map);

          if (event['title'] == state.searchResult) {
            return Slidable(
              startActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) => chatTileEditDialog(
                      isBookmarked: event['favorite'] == 0 ? false : true,
                      key: snapshot.key!,
                      title: event['title'],
                      context: context,
                    ),
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    foregroundColor: Theme.of(context).primaryColor,
                    icon: Icons.edit,
                  ),
                  SlidableAction(
                    onPressed: (context) => context
                        .read<CategoryListCubit>()
                        .removeEventInCategory(key: snapshot.key!),
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    foregroundColor: Theme.of(context).primaryColor,
                    icon: Icons.delete,
                  ),
                  SlidableAction(
                    autoClose: true,
                    onPressed: (context) {
                      moveTile(context: context, eventKey: snapshot.key!);
                    },
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    foregroundColor: Theme.of(context).primaryColor,
                    icon: Icons.move_down,
                  ),
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
                          iconCode: event['icon'],
                          isSelected: event['isSelected'] == 0 ? false : true,
                          title: event['title'],
                          date: DateTime.parse(event['date']),
                          favorite: event['favorite'] == 0 ? false : true,
                          image: null),
                      Text(' from ${event['categoryTitle']}'),
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
