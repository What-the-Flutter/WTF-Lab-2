import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../data/models/message.dart';
import '../../data/models/post.dart';
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
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _messageController = TextEditingController();
  bool _isSelected = true;
  bool _isEmpty = true;
  File? imageFile;

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

  _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker()
        .getImage(source: ImageSource.camera, maxHeight: 1000, maxWidth: 1000);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
    return imageFile;
  }

  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker()
        .getImage(source: ImageSource.gallery, maxHeight: 1000, maxWidth: 1000);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
    return imageFile;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessagesCubit, MessagesState>(
      builder: (context, state) {
        return Scaffold(
          key: scaffoldKey,
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
                            subtitle: Text(state
                                .messageList[index].createMessageTime
                                .toString()),
                          ),
                        ),
                      );
                    }),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            _isEmpty = false;
                          });
                        } else {
                          setState(() {
                            _isEmpty = true;
                          });
                        }
                      },
                      controller: _messageController,
                      decoration:
                          const InputDecoration(hintText: 'Enter event'),
                    ),
                  ),
                  IconButton(
                    icon: _isEmpty
                        ? const Icon(Icons.camera_enhance_sharp)
                        : const Icon(Icons.send),
                    onPressed: () {
                      if (_isEmpty) {
                        scaffoldKey.currentState!.showBottomSheet(
                          (context) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.deepOrangeAccent,
                                    onPrimary: Colors.black),
                                onPressed: _getFromCamera,
                                icon: const Icon(Icons.camera_enhance_sharp),
                                label: const Text('Open Camera'),
                              ),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.deepOrangeAccent,
                                    onPrimary: Colors.black),
                                onPressed: _getFromGallery,
                                icon: const Icon(Icons.image),
                                label: const Text('Open Gallery'),
                              ),
                            ],
                          ),
                        );
                        final newMessage = Message(
                            textMessage: imageFile!.path,
                            createMessageTime: DateFormat.jm()
                                .format(DateTime.now())
                                .toString());
                        context.read<MessagesCubit>().addMessage(newMessage);
                      } else {
                        final newMessage = Message(
                            textMessage: _messageController.text,
                            createMessageTime: DateFormat.jm()
                                .format(DateTime.now())
                                .toString());
                        context.read<MessagesCubit>().addMessage(newMessage);
                      }
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
