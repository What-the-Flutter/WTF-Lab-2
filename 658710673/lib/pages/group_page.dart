import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/event.dart';
import '../utils/constants.dart';

class GroupPage extends StatefulWidget {
  final String title;

  const GroupPage({Key? key, required this.title}) : super(key: key);

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  List<Event> events = [];
  List<int> selectedEventsIndexes = [];
  List<int> favoriteEventsIndexes = [];
  int? editableEventIndex;
  bool writingMode = false;
  bool editingMode = false;
  bool favoriteMode = false;
  File? attachment;
  String? filePath = '';

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
        appBar: selectedEventsIndexes.isEmpty && !editingMode
            ? _appBar()
            : _editAppBar(context),
        body: Stack(
          children: [
            events.isEmpty
                ? _bodyWithoutEvents()
                : favoriteMode
                    ? _bodyFavoriteEvents()
                    : _bodyWithEvents(),
            Align(
              alignment: Alignment.bottomLeft,
              child: _inputTextField(),
            )
          ],
        ));
  }

  AppBar _appBar() {
    return AppBar(
      title: Center(
        child: Text(widget.title),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {},
        ),
        IconButton(
          icon: favoriteMode
              ? const Icon(Icons.bookmark)
              : const Icon(Icons.bookmark_border),
          onPressed: () {
            setState((() => favoriteMode = favoriteMode ? false : true));
          },
        ),
      ],
    );
  }

  AppBar _editAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          setState(() {
            selectedEventsIndexes.clear();
          });
        },
      ),
      title: Center(
        child: Text(selectedEventsIndexes.length.toString()),
      ),
      actions: [
        if (selectedEventsIndexes.length == 1)
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              setState(() {
                controller.text = events[selectedEventsIndexes[0]].description;
                editingMode = true;
                selectedEventsIndexes.clear();
              });
            },
          ),
        IconButton(
          icon: const Icon(Icons.copy),
          onPressed: () {
            var selectedText = '';
            for (var i in selectedEventsIndexes) {
              selectedText += '${events[i].toString()}\n';
            }
            Clipboard.setData(ClipboardData(text: selectedText));
            setState(() {
              selectedEventsIndexes.clear();
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.bookmark_border),
          onPressed: () {
            setState(() {
              favoriteEventsIndexes.addAll(selectedEventsIndexes);
              selectedEventsIndexes.clear();
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: _dialog,
        ),
      ],
    );
  }

  Container _bodyWithoutEvents() {
    return Container(
      margin: const EdgeInsets.all(20),
      alignment: Alignment.center,
      width: 400,
      height: 260,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'This is the page where you can track everything about "${widget.title}"!',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 17),
          ),
          const SizedBox(
            height: 18,
          ),
          Text(
            'Add your first event to "${widget.title}" page by entering some text in the text box below and hitting the send button. '
            'Long tap the send button to align the event in the opposite direction. Tap on the bookmark icon on the top right corner to '
            'show the bookmarked events only.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          )
        ],
      ),
    );
  }

  Expanded _bodyWithEvents() {
    return Expanded(
      child: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) => Align(
          alignment: Alignment.bottomLeft,
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
                selectedEventsIndexes.add(index);
                editableEventIndex = index;
              });
            },
            child: _eventMessage(index),
          ),
        ),
      ),
    );
  }

  Expanded _bodyFavoriteEvents() {
    return Expanded(
      child: ListView.builder(
        itemCount: favoriteEventsIndexes.length,
        itemBuilder: (context, index) => Align(
          alignment: Alignment.bottomLeft,
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
                selectedEventsIndexes.add(index);
                editableEventIndex = index;
              });
            },
            child: _eventMessage(favoriteEventsIndexes[index]),
          ),
        ),
      ),
    );
  }

  void _tapOnEvent(int index) {
    if (selectedEventsIndexes.isNotEmpty) {
      if (selectedEventsIndexes.contains(index)) {
        selectedEventsIndexes.remove(index);
      } else {
        editableEventIndex = index;
        selectedEventsIndexes.add(index);
      }
    } else {
      if (favoriteEventsIndexes.contains(index)) {
        favoriteEventsIndexes.remove(index);
      } else {
        favoriteEventsIndexes.add(index);
      }
    }
  }

  Container _eventMessage(int index) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: selectedEventsIndexes.contains(index)
            ? Constants.selectedMessageColor
            : Constants.messageColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            events[index].description.toString(),
            style: const TextStyle(fontSize: 18),
          ),
          if (events[index].attachment != null)
            Image.file(events[index].attachment!),
          Wrap(
            children: [
              if (selectedEventsIndexes.contains(index))
                const Icon(Icons.done, size: 12),
              Text(
                DateFormat()
                    .add_jm()
                    .format(events[index].timeOfCreation)
                    .toString(),
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.black87,
                ),
              ),
              if (favoriteEventsIndexes.contains(index))
                const Icon(Icons.bookmark, size: 12),
            ],
          )
        ],
      ),
    );
  }

  Container _inputTextField() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 5, 0, 5),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            onChanged: (text) {
              setState(() {
                writingMode = text.isEmpty ? false : true;
              });
            },
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
              hintText: 'Enter event',
              filled: true,
              contentPadding: const EdgeInsets.all(10),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none),
            ),
            controller: controller,
          )),
          writingMode
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      if (controller.text.replaceAll('\n', '').isEmpty) {
                        return;
                      }
                      if (editingMode) {
                        events[editableEventIndex!].description =
                            controller.text;
                        editingMode = false;
                        editableEventIndex = null;
                      } else {
                        var event = Event(controller.text);
                        if (attachment != null) event.attachment = attachment;
                        events.add(Event(controller.text));
                      }
                      controller.text = '';
                      writingMode = false;
                    });
                  },
                  icon: const Icon(Icons.send))
              : IconButton(onPressed: () {}, icon: const Icon(Icons.image))
        ],
      ),
    );
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
                for (var i in selectedEventsIndexes) {
                  events.removeAt(i);
                  favoriteEventsIndexes.removeWhere(
                      (item) => selectedEventsIndexes.contains(item));
                }
                selectedEventsIndexes.clear();
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

  Future _attachImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) return;
    setState(() => attachment = File(image.path));
  }

  Future getImage() async {
    var prefs = await SharedPreferences.getInstance();
    var check = prefs.containsKey('image');
    if (check) {
      setState(() {
        filePath = prefs.getString('image');
      });
      return;
    }
    var imagePicker = ImagePicker();
    var image = await imagePicker.pickImage(source: ImageSource.gallery);
    var imagePath = image?.path;
    await prefs.setString('image', imagePath!);
    setState(() {
      attachment = File(prefs.getString('image')!);
    });
  }
}
