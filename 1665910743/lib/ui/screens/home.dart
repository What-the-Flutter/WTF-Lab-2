import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/event_categyory.dart';
import 'chat_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = TextEditingController();

  Future<void> _displayTextInputDialog({
    required BuildContext context,
    required EventCategory list,
  }) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Rename your event'),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      if (list.pined == false) {
                        list.pined = true;
                        context.read<CategoryList>().pin(list);
                        context.read<CategoryList>().remove(list);
                      } else {
                        list.pined = true;
                        context.read<CategoryList>().unpin(list);
                        context.read<CategoryList>().add(list);
                      }

                      Navigator.pop(context);
                    });
                  },
                  icon: list.pined
                      ? const Icon(Icons.bookmark)
                      : const Icon(Icons.bookmark_border)),
              TextButton(
                  onPressed: () {
                    setState(() {
                      list.title = _controller.text;
                      Navigator.pop(context);
                    });
                  },
                  child: const Text('Rename')),
              IconButton(
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
                icon: const Icon(Icons.delete_forever),
              )
            ],
            content: TextField(
              controller: _controller,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final list = context.watch<CategoryList>().categoryList;
    final pinedLIst = context.watch<CategoryList>().pinedList;

    return Container(
      padding: kListViewPadding,
      child: (list.isEmpty && pinedLIst.isEmpty)
          ? const Center(
              child: Text('Nothing to show... yet'),
            )
          : Column(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: pinedLIst
                      .map((e) => ListTile(
                          leading: CircleAvatar(child: e.icon),
                          title: Text(e.title),
                          subtitle: e.list.isEmpty
                              ? const Text('No events')
                              : Text(e.list.last.title),
                          onLongPress: () => _displayTextInputDialog(
                                context: context,
                                list: e,
                              ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(event: e),
                              ),
                            );
                          },
                          trailing: const Icon(Icons.push_pin_outlined)))
                      .toList(),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, i) {
                      return ListTile(
                        leading: CircleAvatar(child: list[i].icon),
                        title: Text(list[i].title),
                        subtitle: list[i].list.isEmpty
                            ? const Text('No events')
                            : Text(list[i].list.last.title),
                        onLongPress: () => _displayTextInputDialog(
                          context: context,
                          list: list[i],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(event: list[i]),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
