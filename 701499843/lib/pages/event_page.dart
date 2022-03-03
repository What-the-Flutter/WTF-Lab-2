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
  bool _editMode = false;
  bool _favoriteMode = false;
  bool _writingMode = false;
  String? _image;

  Future attachImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) return;
    setState(() => _image = image.path);
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
      appBar: !_editMode ? _appBar() : _editAppBar(context),
      body: Column(
        children: [
          allEvents.isEmpty
              ? _bodyWithoutEvents()
              : _favoriteMode
                  ? _bodyFavorite()
                  : _bodyWithEvents(),
          Align(
            child: _inputTextField(),
            alignment: Alignment.bottomCenter,
          ),
        ],
      ),
    );
  }

  Center _bodyWithoutEvents() {
    return Center(
      child: Container(
        width: 400,
        height: 400,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
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
                style: TextStyle(
                    fontSize: 18, color: Theme.of(context).bottomAppBarColor),
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
                _writingMode = text.isNotEmpty;
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
        _writingMode
            ? _sendIconButton()
            : IconButton(
                onPressed: attachImage,
                icon: const Icon(
                  Icons.image,
                ),
              )
      ],
    );
  }

  IconButton _sendIconButton() {
    return IconButton(
      onPressed: () {
        setState(() {
          if (controller.text.replaceAll('\n', '').isEmpty) {
            return;
          }
          if (_editMode) {
            var event =
                allEvents.where((element) => element.isSelected == true).first;
            allEvents[allEvents.indexOf(event)] = event.copyWith(
                description: controller.text,
                isSelected: event.isSelected,
                isFavorite: event.isFavorite);
            _editMode = false;
            allEvents.where((element) => element.isSelected == true).forEach(
              (element) {
                element = element.copyWith(
                    description: element.description,
                    isSelected: false,
                    isFavorite: element.isFavorite);
              },
            );
          } else {
            if (_image != null) {
              var event = Event(description: controller.text, image: _image);
              allEvents.add(event);
            } else {
              var event = Event(description: controller.text, image: null);
              allEvents.add(event);
            }
          }
          controller.text = '';
          _writingMode = false;
        });
      },
      icon: const Icon(
        Icons.send,
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      title: Text(widget.title),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          onPressed: (() => {}),
          icon: const Icon(Icons.search),
        ),
        IconButton(
          onPressed: () => setState(
            (() => _favoriteMode = _favoriteMode ? false : true),
          ),
          icon: const Icon(Icons.bookmark_border),
        ),
      ],
    );
  }

  AppBar _editAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      leading: const IconButton(
        onPressed: null,
        icon: Icon(Icons.close),
      ),
      title: const Center(
        child: Text('Edit mode'),
      ),
      actions: [
        if (allEvents.where((element) => element.isSelected == true).length ==
            1)
          IconButton(
            onPressed: () => setState(
              () {
                controller.text = (allEvents
                    .where((element) => element.isSelected == true)
                    .first
                    .description);
                _editMode = true;
                for (var element in allEvents) {
                  element = element.copyWith(
                      isSelected: false,
                      description: element.description,
                      isFavorite: element.isFavorite);
                }
              },
            ),
            icon: const Icon(Icons.edit),
          ),
        IconButton(
          onPressed: () {
            var text = '';
            var it = allEvents
                .where((element) => element.isSelected == true)
                .iterator;
            while (it.moveNext()) {
              text += '${it.current.description}' '\n';
            }

            Clipboard.setData(ClipboardData(text: text));
            for (var element in allEvents) {
              element = element.copyWith(
                  isSelected: false,
                  description: element.description,
                  isFavorite: element.isFavorite);
            }
          },
          icon: const Icon(Icons.copy),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              allEvents
                  .where((element) => element.isSelected == true)
                  .forEach((element) {
                element.copyWith(
                    description: element.description,
                    isSelected: element.isSelected,
                    isFavorite: true);
              });
              for (var element in allEvents) {
                element = element.copyWith(
                    isSelected: false,
                    description: element.description,
                    isFavorite: element.isFavorite);
              }
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
        itemCount:
            allEvents.where((element) => element.isFavorite == true).length,
        itemBuilder: (context, index) => Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _tapOnEvent(index);
              });
            },
            onLongPress: () {
              setState(() {
                _editMode = true;
                allEvents[index] = allEvents[index].copyWith(
                    description: allEvents[index].description,
                    isSelected: true,
                    isFavorite: allEvents[index].isFavorite);
              });
            },
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: allEvents[index].isFavorite
                      ? Colors.green[300]
                      : Colors.green[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_image != null)
                      Image.file(
                        File(_image!),
                        width: 100,
                        height: 100,
                      ),
                    Text(
                      allEvents[index].description,
                      style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).scaffoldBackgroundColor),
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
                    if (allEvents[index].isFavorite)
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
            onTap: () => setState(
              () {
                _tapOnEvent(index);
              },
            ),
            onLongPress: () {
              setState(() {
                _editMode = true;

                allEvents[index] = allEvents[index].copyWith(
                    description: allEvents[index].description,
                    isSelected: true,
                    isFavorite: allEvents[index].isFavorite);
              });
            },
            child: _eventMessage(index),
          ),
        ),
      ),
    );
  }

  void _tapOnEvent(int index) {
    if (allEvents.where((element) => element.isSelected == true).isNotEmpty) {
      if (allEvents[index].isSelected) {
        allEvents[index] = allEvents[index].copyWith(
            description: allEvents[index].description,
            isSelected: false,
            isFavorite: allEvents[index].isFavorite);
      } else {
        allEvents[index] = allEvents[index].copyWith(
            description: allEvents[index].description,
            isSelected: true,
            isFavorite: allEvents[index].isFavorite);
      }
    } else {
      if (allEvents[index].isFavorite) {
        allEvents[index] = allEvents[index].copyWith(
            description: allEvents[index].description,
            isSelected: allEvents[index].isSelected,
            isFavorite: false);
      } else {
        allEvents[index] = allEvents[index].copyWith(
            description: allEvents[index].description,
            isSelected: allEvents[index].isSelected,
            isFavorite: true);
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
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).primaryColor),
            ),
            onPressed: () {
              setState(() {
                allEvents.removeWhere((element) => element.isSelected == true);
              });
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).primaryColor),
            ),
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
        color:
            allEvents[index].isSelected ? Colors.green[300] : Colors.green[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            allEvents[index].description,
            style: TextStyle(
                fontSize: 18, color: Theme.of(context).scaffoldBackgroundColor),
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
          if (allEvents[index].isFavorite)
            const Icon(Icons.bookmark_add, size: 12),
          if (allEvents[index].image != null)
            Image.file(
              File(allEvents[index].image!),
            ),
        ],
      ),
    );
  }
}
