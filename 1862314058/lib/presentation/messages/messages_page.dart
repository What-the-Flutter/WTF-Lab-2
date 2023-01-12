import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../data/models/message.dart';
import '../../data/models/post.dart';
import '../../repository/firebase_repository.dart';
import 'messages_cubit.dart';
import 'messages_state.dart';

class MessagesPage extends StatefulWidget {
  final Post item;
  final int index;

  const MessagesPage({
    super.key,
    required this.item,
    required this.index,
  });

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _messageController = TextEditingController();
  bool _isEmpty = true;
  File? imageFile;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<MessagesCubit>(context).init(widget.item);
  }

  Future _getFromCamera() async {
    final imagePicker = ImagePicker();
    XFile? pickedFile;

    pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
    }
    final newMess = Message(
      id: DateTime.now().millisecondsSinceEpoch.toInt(),
      textMessage: imageFile!.path,
      createMessageTime: DateFormat.jm().format(DateTime.now()).toString(),
      typeMessage: MessageType.image,
    );
    context.read<MessagesCubit>().addMessage(newMess);
  }

  Future _getFromGallery() async {
    final imagePicker = ImagePicker();
    XFile? pickedFile;

    pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
    }
    final newMess = Message(
        id: DateTime.now().millisecondsSinceEpoch.toInt(),
        textMessage: imageFile!.path,
        createMessageTime: DateFormat.jm().format(DateTime.now()).toString(),
        typeMessage: MessageType.image);
    context.read<MessagesCubit>().addMessage(newMess);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessagesCubit, MessagesState>(
      builder: (context, state) {
        return Scaffold(
          key: scaffoldKey,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: state.editMode ? _selectBar(context, state) : _defaultBar(),
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
                        onLongPress: () =>
                            BlocProvider.of<MessagesCubit>(context)
                              ..changeEditMode()
                              ..isSelectMessage(index),
                        child: Row(
                          children: [
                            state.messageList[index].typeMessage ==
                                    MessageType.text
                                ? SizedBox(
                                    height: 60,
                                    width: 120,
                                    child: Card(
                                      elevation: 15,
                                      color: Colors.lightGreenAccent,
                                      child: InkWell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                state.messageList[index]
                                                    .textMessage,
                                              ),
                                              Text(
                                                state.messageList[index]
                                                    .createMessageTime,
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : SizedBox(
                                    height: 150,
                                    width: 120,
                                    child: Card(
                                      elevation: 15,
                                      color: Colors.lightGreenAccent,
                                      child: InkWell(
                                        onTap: () {},
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Column(
                                            children: [
                                              Image.file(
                                                File(
                                                  state.messageList[index]
                                                      .textMessage,
                                                ),
                                                height: 110,
                                                width: 100,
                                              ),
                                              Text(
                                                state.messageList[index]
                                                    .createMessageTime,
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
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
                      decoration: const InputDecoration(
                        hintText: 'Enter event...',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: _isEmpty
                        ? const Icon(Icons.camera_enhance_sharp)
                        : const Icon(Icons.send),
                    onPressed: () {
                      if (_isEmpty) {
                        openMediaDialog();
                      } else {
                        final newMessage = Message(
                          id: DateTime.now().millisecondsSinceEpoch.toInt(),
                          textMessage: _messageController.text,
                          createMessageTime:
                              DateFormat.jm().format(DateTime.now()).toString(),
                          typeMessage: MessageType.text,
                        );
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
      title: Text(widget.item.title),
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

  AppBar _selectBar(BuildContext context, MessagesState state) {
    return AppBar(
      title: const Text('count select'),
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          context.read<MessagesCubit>().cancelSelectMessage();
        },
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.copy),
          onPressed: () {
            BlocProvider.of<MessagesCubit>(context).copyClipboardMessage();
          },
        ),
        const Icon(Icons.bookmark_border),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            BlocProvider.of<MessagesCubit>(context).deleteMessage();
          },
        ),
      ],
      backgroundColor: Colors.deepPurple,
    );
  }

  void openMediaDialog() {
    scaffoldKey.currentState!.showBottomSheet(
      (context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                primary: Colors.deepOrangeAccent, onPrimary: Colors.black),
            onPressed: _getFromCamera,
            icon: const Icon(Icons.camera_enhance_sharp),
            label: const Text('Open Camera'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                primary: Colors.deepOrangeAccent, onPrimary: Colors.black),
            onPressed: _getFromGallery,
            icon: const Icon(Icons.image),
            label: const Text('Open Gallery'),
          ),
        ],
      ),
    );
  }
}
