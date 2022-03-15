import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../models/event.dart';
import '../widgets/event_tile.dart';
import 'bookmarks.dart';

class ChatScreen extends StatelessWidget {
  final String title;

  ChatScreen({
    Key? key,
    required this.title,
  }) : super(key: key);

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
  final picker = ImagePicker();
  File? _image;

  final List<Event> _eventList = [];

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
                      _eventList[index].favorite = !_eventList[index].favorite;
                      Navigator.pop(context);
                    });
                  },
                  icon: _eventList[index].favorite
                      ? const Icon(Icons.bookmark)
                      : const Icon(Icons.bookmark_border)),
              TextButton(
                  onPressed: () {
                    setState(() {
                      _eventList[index].title = _renameController.text;
                      Navigator.pop(context);
                    });
                  },
                  child: const Text('Rename')),
              IconButton(
                onPressed: () {
                  setState(() {
                    _eventList.removeAt(index);
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
    Clipboard.setData(ClipboardData(text: _eventList[index].title)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Text copied to clipboard')));
    });
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
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
                          list: _eventList,
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
          onPressed: () async {
            if (_controller.value.text.isNotEmpty) {
              setState(() {
                _eventList.add(Event(
                    title: _controller.text,
                    date: DateTime.now(),
                    favorite: false));
                _controller.clear();
              });
            } else {
              await getImage();
              if (_image != null) {
                setState(() {
                  _eventList.add(Event(
                      title: 'Image from gallery',
                      date: DateTime.now(),
                      favorite: false,
                      image: _image));
                });
              }
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
            itemCount: _eventList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _displayTextInputDialog(context, index),
                onLongPress: () => _copyToClipboard(index),
                child: EventTile(
                  title: _eventList[index].title,
                  date: _eventList[index].date,
                  favorite: _eventList[index].favorite,
                  image: _eventList[index].image,
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
