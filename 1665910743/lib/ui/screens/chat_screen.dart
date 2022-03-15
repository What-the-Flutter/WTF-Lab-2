import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/event.dart';
import '../widgets/event_tile.dart';
import 'bookmarks.dart';

class ChatScreen extends StatelessWidget {
  final String title;

  ChatScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.extension_sharp),
          ),
        ],
      ),
      body: const _ChatScreenBody(),
    );
  }
}

class _ChatScreenBody extends StatefulWidget {
  const _ChatScreenBody({Key? key}) : super(key: key);

  @override
  State<_ChatScreenBody> createState() => __ChatScreenBodyState();
}

class __ChatScreenBodyState extends State<_ChatScreenBody> {
  final _controller = TextEditingController();
  final _renameController = TextEditingController();
  final List<Event> _test = [];

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _renameController.dispose();
    super.dispose();
  }

  Future<void> _displayTextInputDialog(BuildContext context, int index) async {
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
                      _test[index].favorite = !_test[index].favorite;
                      Navigator.pop(context);
                    });
                  },
                  icon: _test[index].favorite
                      ? const Icon(Icons.bookmark)
                      : const Icon(Icons.bookmark_border)),
              TextButton(
                  onPressed: () {
                    setState(() {
                      _test[index].title = _renameController.text;
                      Navigator.pop(context);
                    });
                  },
                  child: const Text('Rename')),
              IconButton(
                onPressed: () {
                  setState(() {
                    _test.removeAt(index);
                    Navigator.pop(context);
                  });
                },
                icon: const Icon(Icons.delete_forever),
              )
            ],
            content: TextField(
              controller: _renameController,
            ),
          );
        });
  }

  void _copyToClipboard(int index) {
    Clipboard.setData(ClipboardData(text: _test[index].title)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Text copied to clipboard')));
    });
  }

  Row _chatScreenNavBar() {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BookmarkEvents(
                          list: _test,
                        )));
          },
          icon: const Icon(Icons.bookmark),
        ),
        Expanded(
          child: TextField(
            decoration: const InputDecoration(
              hintText: ' Enter event',
              border: InputBorder.none,
            ),
            controller: _controller,
          ),
        ),
        IconButton(
          onPressed: () {
            if (_controller.value.text.isNotEmpty) {
              setState(() {
                _test.add(Event(
                    title: _controller.text,
                    date: DateTime.now(),
                    favorite: false));
                _controller.clear();
              });
            }
          },
          icon: _controller.value.text.isEmpty
              ? const Icon(Icons.photo_camera)
              : const Icon(Icons.send),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Column(children: [
        Expanded(
          child: ListView.builder(
            itemCount: _test.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _displayTextInputDialog(context, index),
                onLongPress: () => _copyToClipboard(index),
                child: EventTile(
                  title: _test[index].title,
                  date: _test[index].date,
                  favorite: _test[index].favorite,
                ),
              );
            },
          ),
        ),
        _chatScreenNavBar(),
      ]),
    );
  }
}
