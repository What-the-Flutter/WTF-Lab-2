import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class EventScreen extends StatefulWidget {
  const EventScreen(this.text, {Key? key}) : super(key: key);
  final String text;
  @override
  _State createState() => _State();
}

class _State extends State<EventScreen> {
  List<Event> events = [];
  List<Event> markedEvents = [];
  List<Event> selectedEvents = [];
  List<int> editingIndexes = [];
  bool editMod = false;
  bool bookmarkMod = false;
  bool isWriting = false;

  File? image;
  Future pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) return;
    final imageTemporary = File(image.path);
    setState(() => this.image = imageTemporary);
  }

  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: selectedEvents.isEmpty && !editMod
          ? _defaultAppBar(context)
          : _editAppBar(context),
      body: Column(
        children: [
          events.isEmpty
              ? Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            'This is the page where you can track everything about ${widget.text}!\n',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Text(
                            'Add your first event to ${widget.text} page by entering some text in the text below and hitting the send button. Long tap the send button to allign the event in the opposite direction. Tap on the bookmark icon on the top right corner to show the bookbark events only.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : bookmarkMod
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: markedEvents.length,
                        itemBuilder: (context, index) => Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (selectedEvents.isNotEmpty) {
                                  if (selectedEvents.contains(events[index])) {
                                    selectedEvents.remove(events[index]);
                                  } else {
                                    editingIndexes.add(index);
                                    selectedEvents.add(events[index]);
                                  }
                                } else {
                                  if (markedEvents.contains(events[index])) {
                                    markedEvents.remove(events[index]);
                                  } else {
                                    markedEvents.add(events[index]);
                                  }
                                }
                              });
                            },
                            onLongPress: () {
                              setState(() {
                                selectedEvents.add(events[index]);
                                editingIndexes.add(index);
                              });
                            },
                            child: Center(
                              child: Container(
                                margin: const EdgeInsets.all(8),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: selectedEvents
                                          .contains(markedEvents[index])
                                      ? Colors.green[300]
                                      : Colors.green[100],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (image != null)
                                      Image.file(
                                        image!,
                                        width: 100,
                                        height: 100,
                                      ),
                                    Text(
                                      markedEvents[index].text,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    Text(
                                      DateFormat()
                                          .add_jm()
                                          .format(
                                              markedEvents[index].timeCreated)
                                          .toString(),
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF616161),
                                      ),
                                    ),
                                    if (markedEvents
                                        .contains(markedEvents[index]))
                                      const Icon(Icons.bookmark_add, size: 12)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: events.length,
                        itemBuilder: (context, index) => Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (selectedEvents.isNotEmpty) {
                                  if (selectedEvents.contains(events[index])) {
                                    selectedEvents.remove(events[index]);
                                  } else {
                                    editingIndexes.add(index);
                                    selectedEvents.add(events[index]);
                                  }
                                } else {
                                  if (markedEvents.contains(events[index])) {
                                    markedEvents.remove(events[index]);
                                  } else {
                                    markedEvents.add(events[index]);
                                  }
                                }
                              });
                            },
                            onLongPress: () {
                              setState(() {
                                selectedEvents.add(events[index]);
                                editingIndexes.add(index);
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.all(8),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: selectedEvents.contains(events[index])
                                    ? Colors.green[300]
                                    : Colors.green[100],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    events[index].text,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    DateFormat()
                                        .add_jm()
                                        .format(events[index].timeCreated)
                                        .toString(),
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF616161),
                                    ),
                                  ),
                                  if (markedEvents.contains(events[index]))
                                    const Icon(Icons.bookmark_add, size: 12)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.access_alarm),
              ),
              Expanded(
                child: TextField(
                  onChanged: (text) {
                    setState(() {
                      isWriting = text.isEmpty ? false : true;
                    });
                  },
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? 9
                          : 1,
                  decoration: const InputDecoration(
                    hintText: 'Enter Event',
                    filled: true,
                  ),
                  controller: textController,
                ),
              ),
              isWriting
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          if (textController.text
                              .replaceAll('\n', '')
                              .isEmpty) {
                            return;
                          }
                          if (editMod) {
                            events[editingIndexes[0]].text =
                                textController.text;
                            editMod = false;
                            editingIndexes.clear();
                          } else {
                            events.add(Event(textController.text));
                          }
                          textController.text = '';
                        });
                      },
                      icon: const Icon(
                        Icons.send,
                      ),
                    )
                  : IconButton(
                      onPressed: pickImage,
                      icon: const Icon(
                        Icons.image,
                      ),
                    )
            ],
          ),
        ],
      ),
    );
  }

  AppBar _defaultAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back),
      ),
      title: Center(
        child: Text(widget.text),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              bookmarkMod = bookmarkMod ? false : true;
            });
          },
          icon: bookmarkMod
              ? const Icon(
                  Icons.bookmark,
                  color: Colors.yellow,
                )
              : const Icon(Icons.bookmark_outline),
        ),
      ],
    );
  }

  AppBar _editAppBar(BuildContext context) {
    return editMod
        ? _editModAppBar(context)
        : AppBar(
            leading: IconButton(
              onPressed: () {
                setState(() {
                  selectedEvents.clear();
                });
              },
              icon: const Icon(Icons.close),
            ),
            title: Center(
              child: Text(selectedEvents.length.toString()),
            ),
            actions: [
              if (selectedEvents.length == 1)
                IconButton(
                  onPressed: () {
                    setState(() {
                      textController.text = selectedEvents[0].text;
                      editMod = true;
                      selectedEvents.clear();
                    });
                  },
                  icon: const Icon(Icons.edit),
                ),
              IconButton(
                onPressed: () {
                  Clipboard.setData(
                      ClipboardData(text: selectedEvents.join('\n')));
                  setState(() {
                    selectedEvents.clear();
                  });
                },
                icon: const Icon(Icons.copy),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    markedEvents.addAll(selectedEvents);
                    selectedEvents.clear();
                  });
                },
                icon: const Icon(Icons.bookmark_outline),
              ),
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) => Container(
                            margin: const EdgeInsets.all(8.0),
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.centerLeft,
                            height: 150,
                            child: Column(
                              children: [
                                const Text(
                                  'Delete Entry(s)?\n',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  'Are you sure you want to delete the ${selectedEvents.length} selected events?',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Container(
                                        width: 150,
                                        decoration: BoxDecoration(
                                          color: Colors.green[100],
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: IconButton(
                                          color: Colors.red,
                                          iconSize: 30,
                                          onPressed: () {
                                            setState(() {
                                              events.removeWhere((item) =>
                                                  selectedEvents
                                                      .contains(item));
                                              markedEvents.removeWhere((item) =>
                                                  selectedEvents
                                                      .contains(item));
                                              selectedEvents.clear();
                                            });
                                            Navigator.pop(context);
                                          },
                                          icon: const Icon(Icons.delete),
                                        ),
                                      ),
                                      Container(
                                        width: 150,
                                        decoration: BoxDecoration(
                                          color: Colors.green[100],
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: IconButton(
                                          iconSize: 30,
                                          color: Colors.blue,
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          icon: const Icon(Icons.cancel),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ));
                },
                icon: const Icon(Icons.delete),
              ),
            ],
          );
  }

  AppBar _editModAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          setState(() {
            editMod = false;
            textController.text = '';
          });
        },
        icon: const Icon(Icons.arrow_back),
      ),
      title: const Center(
        child: Text('Edit Mode'),
      ),
      actions: [
        IconButton(
            onPressed: () {
              setState(() {
                editMod = false;
                textController.text = '';
              });
            },
            icon: const Icon(Icons.close)),
      ],
    );
  }
}

class Event {
  Event(this.text);
  DateTime timeCreated = DateTime.now();
  String text;
  @override
  String toString() {
    return text;
  }
}
