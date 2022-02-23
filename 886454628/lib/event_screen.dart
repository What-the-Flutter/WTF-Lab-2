import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'data.dart';

class EventScreen extends StatefulWidget {
  const EventScreen(this.page, {Key? key}) : super(key: key);
  final MyPage page;
  @override
  _State createState() => _State();
}

class _State extends State<EventScreen> {
  final List<Event> _markedEvents = [];
  final List<Event> _selectedEvents = [];
  final List<int> _editingIndexes = [];
  final textController = TextEditingController();

  bool _editMod = false;
  bool _bookmarkMod = false;
  bool _isWriting = false;

  File? _image;

  // поля, конструкторы, методы
  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: _appBarSelector(context),
      body: Column(
        children: [
          widget.page.events.isEmpty
              ? _noEventsContainer()
              : _bookmarkMod
                  ? _eventsContainer(_markedEvents)
                  : _eventsContainer(widget.page.events),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.access_alarm),
              ),
              Expanded(
                child: TextField(
                  onChanged: (text) =>
                      setState(() => _isWriting = text.isEmpty ? false : true),
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
              _isWriting
                  ? _sendButton()
                  : IconButton(
                      onPressed: pickImage,
                      icon: const Icon(
                        Icons.image,
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }

  IconButton _sendButton() {
    return IconButton(
      onPressed: () {
        setState(
          () {
            if (textController.text.replaceAll('\n', '').isEmpty) {
              return;
            }
            if (_editMod) {
              widget.page.events[_editingIndexes[0]].text = textController.text;
              _editMod = false;
              _editingIndexes.clear();
            } else {
              widget.page.events.add(
                Event(textController.text),
              );
            }
            textController.text = '';
          },
        );
      },
      icon: const Icon(
        Icons.send,
      ),
    );
  }

  Expanded _eventsContainer(List<Event> events) {
    return Expanded(
      child: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) => Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: () {
              setState(
                () {
                  if (_selectedEvents.isNotEmpty) {
                    if (_selectedEvents.contains(events[index])) {
                      _selectedEvents.remove(events[index]);
                    } else {
                      _editingIndexes.add(index);
                      _selectedEvents.add(events[index]);
                    }
                  } else {
                    if (_markedEvents.contains(events[index])) {
                      _markedEvents.remove(events[index]);
                    } else {
                      _markedEvents.add(events[index]);
                    }
                  }
                },
              );
            },
            onLongPress: () {
              setState(
                () {
                  _selectedEvents.add(events[index]);
                  _editingIndexes.add(index);
                },
              );
            },
            child: _messageContainer(events, index),
          ),
        ),
      ),
    );
  }

  Container _messageContainer(List<Event> events, int index) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _selectedEvents.contains(events[index])
            ? Colors.green[300]
            : Colors.green[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (events[index].image != null)
            Image.file(
              _image!,
              width: 100,
              height: 100,
            ),
          Text(
            events[index].text,
            style: const TextStyle(fontSize: 18),
          ),
          Text(
            DateFormat().add_jm().format(events[index].timeCreated).toString(),
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF616161),
            ),
          ),
          if (_markedEvents.contains(events[index]))
            const Icon(Icons.bookmark_add, size: 12),
        ],
      ),
    );
  }

  Expanded _noEventsContainer() {
    return Expanded(
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
                'This is the page where you can track everything about '
                '${widget.page.text}!\n',
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                'Add your first event to ${widget.page.text} page by '
                'entering some text in the text below and hitting the send '
                'button. Long tap the send button to allign the event in the '
                'opposite direction. Tap on the bookmark icon on the top right '
                'corner to show the bookbark events only.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
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
        child: Text(widget.page.text),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search),
        ),
        IconButton(
          onPressed: () => setState(() {
            _bookmarkMod = _bookmarkMod ? false : true;
          }),
          icon: _bookmarkMod
              ? const Icon(
                  Icons.bookmark,
                  color: Colors.yellow,
                )
              : const Icon(Icons.bookmark_outline),
        ),
      ],
    );
  }

  AppBar _selectModAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () => setState(
          _selectedEvents.clear,
        ),
        icon: const Icon(Icons.close),
      ),
      title: Center(
        child: Text(
          _selectedEvents.length.toString(),
        ),
      ),
      actions: [
        if (_selectedEvents.length == 1)
          IconButton(
            onPressed: () => setState(
              () {
                textController.text = _selectedEvents[0].text;
                textController.selection = TextSelection.fromPosition(
                  TextPosition(offset: textController.text.length),
                );
                _editMod = true;
                _selectedEvents.clear();
              },
            ),
            icon: const Icon(Icons.edit),
          ),
        IconButton(
          onPressed: () {
            Clipboard.setData(
              ClipboardData(
                text: _selectedEvents.join('\n'),
              ),
            );
            setState(
              _selectedEvents.clear,
            );
          },
          icon: const Icon(Icons.copy),
        ),
        IconButton(
          onPressed: () => setState(
            () {
              _markedEvents.addAll(_selectedEvents);
              _selectedEvents.clear();
            },
          ),
          icon: const Icon(Icons.bookmark_outline),
        ),
        IconButton(
          onPressed: () => modalDeleteOrCancel(context),
          icon: const Icon(Icons.delete),
        ),
      ],
    );
  }

  Future<dynamic> modalDeleteOrCancel(BuildContext context) {
    return showModalBottomSheet(
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
              'Are you sure you want to delete the '
              '${_selectedEvents.length} selected events?',
              style: const TextStyle(fontSize: 16),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      color: Colors.red,
                      iconSize: 30,
                      onPressed: () {
                        setState(
                          () {
                            widget.page.events
                                .removeWhere(_selectedEvents.contains);
                            _markedEvents.removeWhere(_selectedEvents.contains);
                            _selectedEvents.clear();
                          },
                        );
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ),
                  Container(
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(20),
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
      ),
    );
  }

  AppBar _editModAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          setState(
            () {
              _editMod = false;
              textController.text = '';
            },
          );
        },
        icon: const Icon(Icons.arrow_back),
      ),
      title: const Center(
        child: Text('Edit Mode'),
      ),
      actions: [
        IconButton(
          onPressed: () => setState(
            () {
              _editMod = false;
              textController.text = '';
            },
          ),
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  AppBar _appBarSelector(BuildContext context) {
    return _selectedEvents.isEmpty && !_editMod
        ? _defaultAppBar(context)
        : _editMod
            ? _editModAppBar(context)
            : _selectModAppBar(context);
  }

  Future pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) return;
    final imageTemporary = File(image.path);
    setState(() => _image = imageTemporary);
  }
}
