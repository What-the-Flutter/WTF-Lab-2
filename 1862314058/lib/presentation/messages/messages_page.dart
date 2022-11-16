import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/message.dart';

class MessagesPage extends StatefulWidget {
  final String item;
  final int index;

  const MessagesPage({super.key, required this.item, required this.index});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  List<Message> messagesList = [];
  String? message;
  int currentIndex = 1;

  void addMessage(Message messageModel) {
    setState(() {
      messagesList.add(messageModel);
    });
  }

  void editMessage(int index, Message messageModel) {
    setState(() {
      messagesList.insert(index, messageModel);
    });
  }

  void copyMessage() {}

  void deleteMessage(int index) {
    setState(() {
      messagesList.removeAt(index);
    });
  }

  static final AppBar _defaultBar =
      AppBar(title: const Text('Chat'), centerTitle: true, actions: <Widget>[
    IconButton(
      icon: const Icon(Icons.search),
      onPressed: () {},
    ),
    IconButton(
      icon: const Icon(Icons.bookmark_border),
      onPressed: () {},
    ),
  ]);

  static final AppBar _selectBar = AppBar(
    title: const Text('1*'),
    leading: const Icon(Icons.close),
    actions: <Widget>[
      const Icon(Icons.flag),
      const Icon(Icons.edit),
      const Icon(Icons.copy),
      const Icon(Icons.bookmark_border),
      IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {},
      ),
    ],
    backgroundColor: Colors.deepPurple,
  );

  AppBar _appBar = _defaultBar;

  changeAppBar() {
    setState(() {
      _appBar = _appBar == _defaultBar ? _selectBar : _defaultBar;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('1*'),
        leading: const Icon(Icons.close),
        actions: <Widget>[
          const Icon(Icons.flag),
          const Icon(Icons.edit),
          const Icon(Icons.copy),
          const Icon(Icons.bookmark_border),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              deleteMessage(2);
            },
          ),
        ],
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
                reverse: true,
                itemCount: messagesList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 100, 7),
                    child: GestureDetector(
                      onLongPress: changeAppBar,
                      child: ListTile(
                        tileColor: Colors.grey,
                        title: Text(messagesList[index].textMessage),
                        subtitle: Text(messagesList[index].dateTime.toString()),
                        onTap: () async {
                          await Clipboard.setData(
                            ClipboardData(
                                text: messagesList[index].textMessage),
                          );
                          // copied successfully
                        },
                      ),
                    ),
                  );
                }),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(hintText: 'Enter event'),
                  onChanged: (value) {
                    message = value;
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.playlist_add_outlined),
                onPressed: () {
                  final newMessage =
                      Message(textMessage: message!, dateTime: DateTime.now());
                  addMessage(newMessage);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
