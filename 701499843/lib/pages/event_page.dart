import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../models/event.dart';

class EventPage extends StatefulWidget {
  const EventPage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  List<Event> allEvents = [];
  List<Event> favoriteEvents = [];
  List<Event> selectedEvents = [];
  List<int> editingIndexes = [];
  bool editMode = false;
  bool favoriteMode = false;
  bool writingMode = false;
  File? image;

  Future attachImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) return;
    setState(() => this.image = File(image.path));
  }

  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: selectedEvents.isEmpty && !editMode
          ? _appBar()
          : _editAppBar(context),
      body: Column(
        children: [
          allEvents.isEmpty
              ? _bodyWithoutEvents()
              : favoriteMode
                  ? _bodyFavorite()
                  : _bodyWithEvents(),
        ],
      ),
      bottomNavigationBar: Container(
        child: _inputTextField(),
      ),
    );
  }

  Center _bodyWithoutEvents() {
    return Center(
      child: Container(
        width: 400,
        height: 400,
        decoration: BoxDecoration(
          color: Colors.green[100],
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(18.0),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              Text(
                'This is the page where you can track everything about ${widget.title}!\n',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
              Text(
                'Add your first event to ${widget.title} page by entering some text in the text below and hitting the send button. Long tap the send button to allign the event in the opposite direction. Tap on the bookmark icon on the top right corner to show the bookbark events only.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _inputTextField() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.bubble_chart),
        ),
        Expanded(
          child: TextField(
            onChanged: (text) {
              setState(() {
                writingMode = text.isEmpty ? false : true;
              });
            },
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
              hintText: 'Enter event',
              filled: true,
            ),
            controller: controller,
          ),
        ),
        writingMode
            ? IconButton(
                onPressed: () {
                  setState(() {
                    if (controller.text.replaceAll('\n', '').isEmpty) {
                      return;
                    }
                    if (editMode) {
                      allEvents[editingIndexes[0]].description =
                          controller.text;
                      editMode = false;
                      editingIndexes.clear();
                    } else {
                      var event = Event(controller.text);
                      if (image != null) event.image = image;
                      allEvents.add(Event(controller.text));
                    }
                    controller.text = '';
                    writingMode = false;
                  });
                },
                icon: const Icon(
                  Icons.send,
                ),
              )
            : IconButton(
                onPressed: attachImage,
                icon: const Icon(
                  Icons.image,
                ),
              )
      ],
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(widget.title),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          onPressed: (() => {}),
          icon: const Icon(Icons.search),
        ),
        IconButton(
          onPressed: (() =>
              {setState((() => favoriteMode = favoriteMode ? false : true))}),
          icon: const Icon(Icons.bookmark_border),
        ),
      ],
    );
  }

  AppBar _editAppBar(BuildContext context) {
    return AppBar(
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
                controller.text = selectedEvents[0].description;
                editMode = true;
                selectedEvents.clear();
              });
            },
            icon: const Icon(Icons.edit),
          ),
        IconButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: selectedEvents.join('\n')));
            setState(() {
              selectedEvents.clear();
            });
          },
          icon: const Icon(Icons.copy),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              favoriteEvents.addAll(selectedEvents);
              selectedEvents.clear();
            });
          },
          icon: const Icon(Icons.bookmark_outline),
        ),
        IconButton(
          onPressed: _dialog,
          icon: const Icon(Icons.delete),
        ),
      ],
    );
  }

  Expanded _bodyFavorite() {
    return Expanded(
      child: ListView.builder(
        itemCount: favoriteEvents.length,
        itemBuilder: (context, index) => Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: () {
              setState(() {
                if (selectedEvents.isNotEmpty) {
                  if (selectedEvents.contains(allEvents[index])) {
                    selectedEvents.remove(allEvents[index]);
                  } else {
                    editingIndexes.add(index);
                    selectedEvents.add(allEvents[index]);
                  }
                } else {
                  if (favoriteEvents.contains(allEvents[index])) {
                    favoriteEvents.remove(allEvents[index]);
                  } else {
                    favoriteEvents.add(allEvents[index]);
                  }
                }
              });
            },
            onLongPress: () {
              setState(() {
                selectedEvents.add(allEvents[index]);
                editingIndexes.add(index);
              });
            },
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: selectedEvents.contains(favoriteEvents[index])
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
                      favoriteEvents[index].description,
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      DateFormat()
                          .add_jm()
                          .format(favoriteEvents[index].timeOfCreation)
                          .toString(),
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF616161),
                      ),
                    ),
                    if (favoriteEvents.contains(favoriteEvents[index]))
                      const Icon(Icons.bookmark_add, size: 12)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Expanded _bodyWithEvents() {
    return Expanded(
      child: ListView.builder(
        itemCount: allEvents.length,
        itemBuilder: (context, index) => Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: () {
              setState(
                () {
                  _tapOnEvent(index);
                },
              );
            },
            onLongPress: () {
              setState(() {
                selectedEvents.add(allEvents[index]);
                editingIndexes.add(index);
              });
            },
            child: _eventMessage(index),
          ),
        ),
      ),
    );
  }

  void _tapOnEvent(int index) {
    if (selectedEvents.isNotEmpty) {
      if (selectedEvents.contains(allEvents[index])) {
        selectedEvents.remove(allEvents[index]);
      } else {
        editingIndexes.add(index);
        selectedEvents.add(allEvents[index]);
      }
    } else {
      if (favoriteEvents.contains(allEvents[index])) {
        favoriteEvents.remove(allEvents[index]);
      } else {
        favoriteEvents.add(allEvents[index]);
      }
    }
  }

  void _dialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Do you want to delete events?'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                allEvents.removeWhere((item) => selectedEvents.contains(item));
                favoriteEvents
                    .removeWhere((item) => selectedEvents.contains(item));
                selectedEvents.clear();
              });
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No'),
          )
        ],
      ),
    );
  }

  Container _eventMessage(int index) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: selectedEvents.contains(allEvents[index])
            ? Colors.green[300]
            : Colors.green[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            allEvents[index].description,
            style: const TextStyle(fontSize: 18),
          ),
          Text(
            DateFormat()
                .add_jm()
                .format(allEvents[index].timeOfCreation)
                .toString(),
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF616161),
            ),
          ),
          if (favoriteEvents.contains(allEvents[index]))
            const Icon(Icons.bookmark_add, size: 12),
          if (allEvents[index].image != null)
            Image.file(allEvents[index].image!)
        ],
      ),
    );
  }
}
