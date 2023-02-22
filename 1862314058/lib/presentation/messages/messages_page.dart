import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../data/models/message.dart';
import '../../data/models/post.dart';
import '../../repository/firebase_repository.dart';
import 'messages_cubit.dart';
import 'messages_state.dart';

class MessagesPage extends StatefulWidget {
  final Post postItem;

  const MessagesPage({
    super.key,
    required this.postItem,
  });

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final GlobalKey<ScaffoldState> _messageKey = GlobalKey<ScaffoldState>();
  final TextEditingController _messageController = TextEditingController();
  bool _isEmpty = true;
  File? imageFile;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<MessagesCubit>(context).init(widget.postItem.id);
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
      postId: widget.postItem.id.toString(),
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
        postId: widget.postItem.id.toString(),
        textMessage: imageFile!.path,
        createMessageTime: DateFormat.yMMMd().format(
          DateTime.now(),
        ),
        //DateFormat.jm().format(DateTime.now()).toString(),
        typeMessage: MessageType.image);
    context.read<MessagesCubit>().addMessage(newMess);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessagesCubit, MessagesState>(
      builder: (context, state) {
        return Scaffold(
          key: _messageKey,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child:
                state.isSelected ? _selectBar(context, state) : _defaultBar(),
          ),
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: state.backgroundImage != null
                    ? FileImage(
                        File(state.backgroundImage),
                      )
                    : MemoryImage(kTransparentImage) as ImageProvider,
              ),
            ),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemCount: state.messageList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onLongPress: () =>
                            BlocProvider.of<MessagesCubit>(context)
                                .isSelectMessage(index),
                        child: Row(
                          mainAxisAlignment: state.isBubbleAlignment
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            state.messageList[index].typeMessage ==
                                    MessageType.text
                                ? _textTypeMessage(state, index)
                                : _imageTypeMessage(state, index),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                _textMessageRow(),
              ],
            ),
          ),
        );
      },
    );
  }

  AppBar _defaultBar() {
    return AppBar(
      title: Text(widget.postItem.title),
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
          onPressed: () {
            BlocProvider.of<MessagesCubit>(context)
                .editMessage(_messageController.text);
          },
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
          onPressed: () => _showDeleteMessage(context, state),
        ),
      ],
      backgroundColor: Colors.deepPurple,
    );
  }

  _showDeleteMessage(BuildContext context, MessagesState state) {
    var dialog = AlertDialog(
      title: const Text('Delete entrys?'),
      content: const Text('Are you sure?'),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                BlocProvider.of<MessagesCubit>(context).delete();
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.delete),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.cancel),
            )
          ],
        )
      ],
    );
    var futureResult = showDialog(
        context: context,
        builder: (context) {
          return dialog;
        });
    futureResult.then((value) async {
      await ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Deleted'),
        ),
      );
      BlocProvider.of<MessagesCubit>(context).cancelSelectMessage();
    });
  }

  SizedBox _imageTypeMessage(MessagesState state, int index) {
    return SizedBox(
      height: 150,
      width: 120,
      child: Card(
        elevation: 15,
        color: Colors.lightGreenAccent,
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              children: [
                Image.file(
                  File(
                    state.messageList[index].textMessage,
                  ),
                  height: 110,
                  width: 100,
                ),
                Text(
                  state.messageList[index].createMessageTime,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox _textTypeMessage(MessagesState state, int index) {
    return SizedBox(
      height: 70,
      width: 120,
      child: Card(
        elevation: 15,
        color: Colors.lightGreenAccent,
        child: InkWell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.messageList[index].textMessage,
                ),
                Text(
                  state.messageList[index].createMessageTime,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _textMessageRow() {
    return Row(
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
              _openMediaDialog();
            } else {
              final newMessage = Message(
                id: DateTime.now().millisecondsSinceEpoch.toInt(),
                postId: widget.postItem.id.toString(),
                textMessage: _messageController.text,
                createMessageTime: DateFormat.yMMMd().format(
                  DateTime.now(),
                ),
                    //DateFormat.jm().format(DateTime.now()).toString(),
                typeMessage: MessageType.text,
              );
              context.read<MessagesCubit>().addMessage(newMessage);
            }
          },
        ),
      ],
    );
  }

  void _openMediaDialog() {
    _messageKey.currentState!.showBottomSheet(
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
