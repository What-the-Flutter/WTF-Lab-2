import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../models/event.dart';
import '../utils/app_theme.dart';

class CategoryPage extends StatefulWidget {
  final String title;

  const CategoryPage({Key? key, required this.title}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final List<Event> _events = [];
  final List<int> _selectedEventsIndexes = [];
  final List<int> _favoriteEventsIndexes = [];
  int? _editableEventIndex;
  bool _writingMode = false;
  bool _editingMode = false;
  bool _favoriteMode = false;
  File? _attachment;

  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: _selectedEventsIndexes.isEmpty && !_editingMode
          ? _appBar()
          : _editAppBar(context),
      body: Column(
        children: [
          Expanded(
            child: _events.isEmpty
                ? _bodyWithoutEvents()
                : _favoriteMode
                    ? _bodyFavoriteEvents()
                    : _bodyWithEvents(),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: _inputTextField(),
          )
        ],
      ),
    );
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
          icon: _favoriteMode
              ? const Icon(Icons.bookmark)
              : const Icon(Icons.bookmark_border),
          onPressed: () {
            setState(() => _favoriteMode = _favoriteMode ? false : true);
          },
        ),
      ],
    );
  }

  AppBar _editAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => setState(_selectedEventsIndexes.clear),
      ),
      title: Center(
        child: Text(_selectedEventsIndexes.length.toString()),
      ),
      actions: [
        if (_selectedEventsIndexes.length == 1 &&
            !_isPicture(_selectedEventsIndexes))
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => setState(() {
              _textController.text =
                  _events[_selectedEventsIndexes[0]].description;
              _editingMode = true;
              _selectedEventsIndexes.clear();
            }),
          ),
        IconButton(
          icon: const Icon(Icons.copy),
          onPressed: () {
            var selectedText = '';
            if (_isPicture(_selectedEventsIndexes)) {
              selectedText =
                  _events[_selectedEventsIndexes[0]].attachment!.path;
            } else {
              for (var i in _selectedEventsIndexes) {
                selectedText += '${_events[i].toString()}\n';
              }
            }
            Clipboard.setData(ClipboardData(text: selectedText));
            setState(_selectedEventsIndexes.clear);
          },
        ),
        IconButton(
          icon: const Icon(Icons.bookmark_border),
          onPressed: () => setState(() {
            _favoriteEventsIndexes.addAll(_selectedEventsIndexes);
            _selectedEventsIndexes.clear();
          }),
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: _dialog,
        ),
      ],
    );
  }

  bool _isPicture(List<int> indexes) {
    for (var i in indexes) {
      if (_events[i].attachment != null) return true;
    }
    return false;
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
            'This is the page where you can track everything about '
            '"${widget.title}"!',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 17, color: Colors.black),
          ),
          const SizedBox(
            height: 18,
          ),
          Text(
            'Add your first event to "${widget.title}" page by entering some'
            'text in the text box below and hitting the send button. Long tap '
            'the send button to align the event in the opposite direction. Tap '
            'on the bookmark icon on the top right corner to show the '
            'bookmarked events only.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  ListView _bodyWithEvents() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _events.length,
      itemBuilder: (context, index) => Align(
        alignment: Alignment.bottomLeft,
        child: GestureDetector(
          onTap: () => setState(() => _tapOnEvent(index)),
          onLongPress: () {
            setState(() {
              _selectedEventsIndexes.add(index);
              _editableEventIndex = index;
            });
          },
          child: _eventMessage(index),
        ),
      ),
    );
  }

  ListView _bodyFavoriteEvents() {
    return ListView.builder(
      itemCount: _favoriteEventsIndexes.length,
      itemBuilder: (context, index) => Align(
        alignment: Alignment.bottomLeft,
        child: GestureDetector(
          onTap: () => setState(() => _tapOnEvent(index)),
          onLongPress: () {
            setState(() {
              _selectedEventsIndexes.add(index);
              _editableEventIndex = index;
            });
          },
          child: _eventMessage(_favoriteEventsIndexes[index]),
        ),
      ),
    );
  }

  void _tapOnEvent(int index) {
    if (_selectedEventsIndexes.isNotEmpty) {
      if (_selectedEventsIndexes.contains(index)) {
        _selectedEventsIndexes.remove(index);
      } else {
        _editableEventIndex = index;
        _selectedEventsIndexes.add(index);
      }
    } else {
      if (_favoriteEventsIndexes.contains(index)) {
        _favoriteEventsIndexes.remove(index);
      } else {
        _favoriteEventsIndexes.add(index);
      }
    }
  }

  Container _eventMessage(int index) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: _selectedEventsIndexes.contains(index)
            ? InheritedCustomTheme.of(context).themeData.colorScheme.primary
            : InheritedCustomTheme.of(context).themeData.highlightColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _events[index].description.toString(),
            style: const TextStyle(fontSize: 18),
          ),
          if (_events[index].attachment != null)
            ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: 5.0,
                minWidth: 5.0,
                maxHeight: 200.0,
                maxWidth: 200.0,
              ),
              child: Image.file(_events[index].attachment!),
            ),
          Wrap(
            children: [
              if (_selectedEventsIndexes.contains(index))
                const Icon(Icons.done, size: 12),
              Text(
                DateFormat()
                    .add_jm()
                    .format(_events[index].timeOfCreation)
                    .toString(),
                style: const TextStyle(
                  fontSize: 11,
                ),
              ),
              if (_favoriteEventsIndexes.contains(index))
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
                  _writingMode = text.isEmpty ? false : true;
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
              controller: _textController,
            ),
          ),
          _writingMode
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      if (_textController.text.replaceAll('\n', '').isEmpty) {
                        return;
                      }
                      if (_editingMode) {
                        _events[_editableEventIndex!].description =
                            _textController.text;
                        _editingMode = false;
                        _editableEventIndex = null;
                      } else {
                        _events.add(Event(_textController.text));
                      }
                      _textController.text = '';
                      _writingMode = false;
                    });
                  },
                  icon: const Icon(Icons.send),
                )
              : IconButton(
                  onPressed: _attachImage,
                  icon: const Icon(Icons.image),
                ),
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
                for (var i in _selectedEventsIndexes) {
                  _events.removeAt(i);
                  _favoriteEventsIndexes
                      .removeWhere(_selectedEventsIndexes.contains);
                }
                _selectedEventsIndexes.clear();
              });
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          )
        ],
      ),
    );
  }

  Future _attachImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) return;
    setState(() => _events.add(Event('', attachment: File(image.path))));
  }
}
