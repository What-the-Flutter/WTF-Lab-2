import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants.dart';
import '../../models/event.dart';
import '../screens/bookmarks.dart';
import 'event_tile.dart';

class ChatScreenBody extends StatefulWidget {
  final List<Event> eventList;

  const ChatScreenBody({Key? key, required this.eventList}) : super(key: key);

  @override
  State<ChatScreenBody> createState() => _ChatScreenBodyState();
}

class _ChatScreenBodyState extends State<ChatScreenBody> {
  final _controller = TextEditingController();
  final _renameController = TextEditingController();
  final picker = ImagePicker();
  final List hasSelected = [];
  File? _image;

  @override
  void initState() {
    _controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _renameController.dispose();
    super.dispose();
  }

  Future<void> _displayTextInputDialog(
    BuildContext context,
    int index,
    List<Event> list,
  ) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 5,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(25.0),
              ),
            ),
            title: const Center(child: Text('Rename your event')),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actions: [
              CircleAvatar(
                foregroundColor: Colors.white,
                backgroundColor: Theme.of(context).primaryColor,
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        list[index].favorite =
                            !widget.eventList[index].favorite;
                        Navigator.pop(context);
                      });
                    },
                    icon: list[index].favorite
                        ? Icon(
                            Icons.bookmark,
                            color: Theme.of(context).primaryColor,
                          )
                        : Icon(
                            Icons.bookmark_border,
                            color: Theme.of(context).primaryColor,
                          )),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  setState(() {
                    list[index].title = _renameController.text;
                    Navigator.pop(context);
                  });
                },
                child: const Text(
                  'Rename',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      list.removeAt(index);
                      Navigator.pop(context);
                    });
                  },
                  icon: Icon(
                    Icons.delete_forever,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              )
            ],
            content: TextField(
              controller: _renameController,
            ),
          );
        });
  }

  void _copyToClipboard(int index) {
    Clipboard.setData(ClipboardData(text: widget.eventList[index].title))
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Text copied to clipboard')));
    });
  }

  Row _chatScreenNavBar() {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            if (hasSelected.isEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookmarkEvents(
                    list: widget.eventList,
                  ),
                ),
              );
            } else {
              for (var element in hasSelected) {
                setState(
                  () {
                    widget.eventList.removeWhere(
                        (e) => e.title.hashCode == element.hashCode);
                  },
                );
              }
              hasSelected.clear();
            }
          },
          icon: hasSelected.isNotEmpty
              ? Icon(
                  Icons.delete,
                  color: Theme.of(context).primaryColor,
                )
              : Icon(
                  Icons.bookmark,
                  color: Theme.of(context).primaryColor,
                ),
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
                widget.eventList.add(
                  Event(
                      title: _controller.text,
                      date: DateTime.now(),
                      favorite: false),
                );
                _controller.clear();
              });
            } else if (_controller.value.text.isEmpty) {
              await getImage();
              if (_image != null) {
                setState(() {
                  widget.eventList.add(
                    Event(
                        title: 'Image from gallery',
                        date: DateTime.now(),
                        favorite: false,
                        image: _image),
                  );
                });
              }
            }
          },
          icon: _controller.value.text.isEmpty
              ? Icon(
                  Icons.photo_camera,
                  color: Theme.of(context).primaryColor,
                )
              : Icon(
                  Icons.send,
                  color: Theme.of(context).primaryColor,
                ),
        )
      ],
    );
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: kListViewPadding,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.eventList.length,
              itemBuilder: (context, index) {
                return Align(
                  alignment: Alignment.bottomLeft,
                  child: GestureDetector(
                    onTap: () => _displayTextInputDialog(
                        context, index, widget.eventList),
                    onDoubleTap: () => _copyToClipboard(index),
                    onLongPress: () {
                      setState(() {
                        if (widget.eventList[index].isSelected == false) {
                          hasSelected.add(widget.eventList[index].title);
                        } else {
                          hasSelected.remove(widget.eventList[index].title);
                        }

                        widget.eventList[index].isSelected =
                            !widget.eventList[index].isSelected;
                        HapticFeedback.heavyImpact();
                      });
                    },
                    child: EventTile(
                      isSelected: widget.eventList[index].isSelected,
                      title: widget.eventList[index].title,
                      date: widget.eventList[index].date,
                      favorite: widget.eventList[index].favorite,
                      image: widget.eventList[index].image,
                    ),
                  ),
                );
              },
            ),
          ),
          _chatScreenNavBar(),
        ],
      ),
    );
  }
}
