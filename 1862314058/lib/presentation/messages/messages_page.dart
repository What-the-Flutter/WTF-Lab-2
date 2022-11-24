import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/message.dart';
import '../../data/post.dart';
import 'messages_cubit.dart';
import 'messages_state.dart';

class MessagesPage extends StatefulWidget {
  final Post item;
  final int index;

  const MessagesPage({super.key, required this.item, required this.index});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final TextEditingController _messageController = TextEditingController();
  bool _isSelected = true;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<MessagesCubit>(context).init();
  }

  void changeAppBar() {
    setState(() {
      _isSelected = !_isSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessagesCubit, MessagesState>(
      builder: (context, state) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: _isSelected ? _defaultBar() : _selectBar(2),
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                    reverse: true,
                    itemCount: state.messageList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 100, 7),
                        child: GestureDetector(
                          onLongPress: changeAppBar,
                          child: ListTile(
                            tileColor: Colors.grey,
                            title: Text(state.messageList[index].textMessage),
                            subtitle: Text(
                                state.messageList[index].dateTime.toString()),
                          ),
                        ),
                      );
                    }),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _messageController,
                      decoration:
                          const InputDecoration(hintText: 'Enter event'),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      final newMessage = Message(
                          textMessage: _messageController.text,
                          dateTime: DateTime.now());
                      context.read<MessagesCubit>().addMessage(newMessage);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  AppBar _defaultBar() {
    return AppBar(
      title: const Text('Chat'),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.bookmark_border),
        ),
      ],
    );
  }

  AppBar _selectBar(int index) {
    return AppBar(
      title: const Text('1*'),
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: changeAppBar,
      ),
      actions: <Widget>[
        const Icon(Icons.flag),
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.copy),
          onPressed: () {},
        ),
        const Icon(Icons.bookmark_border),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => context.read<MessagesCubit>().deleteMessage(index),
        ),
      ],
      backgroundColor: Colors.deepPurple,
    );
  }
}
