import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: prefer_relative_imports
import 'package:my_journal/ui/screens/Category_Screen/cubit/category_cubit.dart';

import '../chat_screen/cubit/event_cubit.dart';

Future<void> moveTile({
  required BuildContext context,
  required String eventKey,
  required String categoryName,
}) async {
  return showDialog(
    context: context,
    builder: (context) => MoveTile(
      eventKey: eventKey,
      categoryName: categoryName,
    ),
  );
}

class MoveTile extends StatelessWidget {
  final String categoryName;
  final String eventKey;
  final _user = FirebaseAuth.instance.currentUser;

  MoveTile({
    Key? key,
    required this.eventKey,
    required this.categoryName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 5,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(25.0),
        ),
      ),
      title: Text(
        'Move event to...',
        style: Theme.of(context).textTheme.bodyText1,
      ),
      content: Container(
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width * 0.5,
          child: BlocBuilder<CategoryCubit, CategoryState>(
            bloc: context.read<CategoryCubit>(),
            builder: (context, state) => ListView.builder(
              itemCount: state.categoryList.length,
              itemBuilder: ((context, index) {
                if (categoryName != state.categoryList[index].title) {
                  return ListTile(
                    onTap: (() {
                      context
                          .read<EventCubit>()
                          .moveEvent(eventKey, state.categoryList[index].title);
                      Navigator.pop(context);
                    }),
                    leading: Icon(
                      Icons.circle,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text(
                      state.categoryList[index].title,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              }),
            ),
          )),
    );
  }
}
