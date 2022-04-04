import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/category_cubit/category_list_cubit.dart';

Future<void> moveTile({
  required BuildContext context,
  required String eventKey,
}) async {
  return showDialog(
    context: context,
    builder: (context) => MoveTile(
      eventKey: eventKey,
    ),
  );
}

class MoveTile extends StatefulWidget {
  final String eventKey;

  MoveTile({
    Key? key,
    required this.eventKey,
  }) : super(key: key);

  @override
  State<MoveTile> createState() => _MoveTileState();
}

class _MoveTileState extends State<MoveTile> {
  final _user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 5,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(25.0),
        ),
      ),
      title: const Text('Move event to...'),
      content: Container(
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width * 0.5,
        child: FirebaseAnimatedList(
          query: FirebaseDatabase.instance
              .ref()
              .child(_user?.uid ?? '')
              .child('category'),
          itemBuilder: (context, snapshot, animation, x) {
            var categoryList = Map.from(snapshot.value as Map);

            return GestureDetector(
              onTap: () {
                context
                    .read<CategoryListCubit>()
                    .moveEvent(widget.eventKey, categoryList['title']);
                Navigator.pop(context);
              },
              child: ListTile(
                leading: Icon(
                  Icons.circle,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(categoryList['title']),
              ),
            );
          },
        ),
      ),
    );
  }
}
