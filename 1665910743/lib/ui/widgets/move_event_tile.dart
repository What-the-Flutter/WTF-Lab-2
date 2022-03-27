import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/categorylist_cubit.dart';
import '../screens/chat_screen.dart';

Future<void> moveTile({
  required BuildContext context,
  required int categoryIndex,
  required int eventIndex,
}) async {
  return showDialog(
    context: context,
    builder: (context) => MoveTile(
      eventIndex: eventIndex,
      categoryIndex: categoryIndex,
    ),
  );
}

class MoveTile extends StatefulWidget {
  final int categoryIndex;
  final int eventIndex;

  MoveTile({
    Key? key,
    required this.categoryIndex,
    required this.eventIndex,
  }) : super(key: key);

  @override
  State<MoveTile> createState() => _MoveTileState();
}

class _MoveTileState extends State<MoveTile> {
  //
  var _counter = 0;

  @override
  Widget build(BuildContext context) {
    var state = context.watch<CategorylistCubit>().state;

    return AlertDialog(
      elevation: 5,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(25.0),
        ),
      ),
      title: Container(
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width * 0.8,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: state.categoryList.length,
          itemBuilder: ((context, index) => index != widget.categoryIndex
              ? ListTile(
                  leading: _counter == index
                      ? const Icon(Icons.circle)
                      : const Icon(Icons.circle_outlined),
                  onTap: (() {
                    setState(() {
                      _counter = index;
                    });
                  }),
                  title: Text(state.categoryList[index].title),
                )
              : const SizedBox()),
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(10),
            primary: Theme.of(context).primaryColor,
          ),
          onPressed: (() {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: ((context) => ChatScreen(eventId: _counter)),
              ),
            );
            context.read<CategorylistCubit>().moveEvent(
                  widget.categoryIndex,
                  _counter,
                  widget.eventIndex,
                );
          }),
          child: const Text('Move'),
        )
      ],
    );
  }
}
