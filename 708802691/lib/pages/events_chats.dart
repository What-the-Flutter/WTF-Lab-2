import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'favorites.dart';

class Note {
  final DateTime _dateTime;
  String content;
  bool isFavorite = false;
  bool isSelected = false;
  final bool _rightHanded;

  Note({required dateTime, required this.content, rightHanded = true})
      : _dateTime = dateTime,
        _rightHanded = rightHanded;

  bool get rightHanded {
    return _rightHanded;
  }

  String get time {
    return DateFormat('kk:mm').format(_dateTime).toString();
  }
}

class Event {
  final String _title;
  List<Note> _notes;
  final IconData _icon;

  Event({required icon, required title, required List<Note> notes})
      : _icon = icon,
        _title = title,
        _notes = notes;

  String get title {
    return _title;
  }

  List<Note> get notes {
    return _notes;
  }

  IconData get icon {
    return _icon;
  }

  Note get lastNote {
    if (_notes.isEmpty) {
      return Note(
        dateTime: DateTime(2022),
        content: 'No events. Click to create one.',
      );
    }
    return _notes[_notes.length - 1];
  }
}

class DefaultBody extends StatelessWidget {
  final String title;

  const DefaultBody({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 20),
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            height: 190,
            width: 300,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(216, 205, 176, 0.6),
              border: Border.all(
                color: const Color.fromRGBO(216, 205, 176, 0.6),
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 250,
                  child: Text(
                    'This is the page where you can track everything about $title!',
                    style: const TextStyle(fontSize: 15, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: 250,
                  child: Text(
                    'Add your first event to $title page by entering some text )in the text box below and hitting the send button. Long tap the send button to align the event in opposite direction. Tap on the bookmark icon on the top right corner to show the bookmarked events only.',
                    style: const TextStyle(fontSize: 14, color: Colors.black26),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(),
          ),
        ],
      ),
    );
  }
}

class ChatList extends StatefulWidget {
  final Event event;

  const ChatList({Key? key, required this.event}) : super(key: key);

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  List<int> selected = [];
  bool editingMode = false;
  bool selectingMode = false;
  int? editingIndex;
  late Event event = widget.event;
  TextEditingController noteController = TextEditingController();


  void _editNote(int index) {
    setState(
      () {
        cancelSelectingMode();
        noteController.clear();
        noteController.text = event.notes[index].content;
        editingMode = true;
        editingIndex = index;
      },
    );
  }

  void _changeMark(List<int> indexes) {
    setState(
      () {
        for (var index in indexes) {
          (event.notes[index].isFavorite)
              ? event.notes[index].isFavorite = false
              : event.notes[index].isFavorite = true;
        }
      },
    );
  }

  void addNote(Note newNote) {
    noteController.clear();
    setState(() => event.notes.add(newNote));
  }

  void cancelEditingMode() {
    setState(
      () {
        noteController.clear();
        editingMode = false;
        editingIndex = null;
      },
    );
  }

  void changeNote(String newContent, int index) {
    setState(
      () => event.notes[index].content = newContent,
    );
    noteController.clear();
    cancelEditingMode();
  }

  void cancelSelectingMode() {
    for (var index in selected) {
      event.notes[index].isSelected = false;
    }
    selected.clear();
    setState(
      () => selectingMode = false,
    );
  }

  void _selectingMode(int index) {
    cancelEditingMode();
    if (event.notes[index].isSelected) {
      selected.remove(index);
      event.notes[index].isSelected = false;
    } else {
      selected.add(index);
      event.notes[index].isSelected = true;
    }
    setState(
      () => (selected.isNotEmpty) ? selectingMode = true : selectingMode = false,
    );
  }

  Stack noteField() {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
            height: 60,
            width: double.infinity,
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Builder(
                  builder: (context) {
                    return IconButton(
                      icon: const Icon(
                        Icons.bubble_chart_rounded,
                        color: Color.fromRGBO(28, 33, 53, 1),
                      ),
                      onPressed: () {},
                    );
                  },
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: TextField(
                    autofocus: false,
                    controller: noteController,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      hintText: 'Write note...',
                      hintStyle: TextStyle(color: Colors.black54),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                (editingMode)
                    ? IconButton(
                        onPressed: cancelEditingMode,
                        icon: const Icon(
                          Icons.cancel_rounded,
                        ),
                      )
                    : const SizedBox(
                        width: 15,
                      ),
                GestureDetector(
                  child: const Icon(
                    Icons.send_rounded,
                    color: Color.fromRGBO(28, 33, 53, 1),
                  ),
                  onTap: () {
                    if (noteController.text.isNotEmpty) {
                      (!editingMode)
                          ? addNote(
                              Note(
                                dateTime: DateTime.now(),
                                content: noteController.text,
                                rightHanded: true,
                              ),
                            )
                          : changeNote(noteController.text, editingIndex!);
                    } else if (noteController.text.isEmpty && editingMode) {
                      cancelEditingMode();
                    }
                  },
                  onLongPress: () {
                    if (noteController.text.isNotEmpty) {
                      (!editingMode)
                          ? addNote(
                              Note(
                                dateTime: DateTime.now(),
                                content: noteController.text,
                                rightHanded: false,
                              ),
                            )
                          : changeNote(
                              noteController.text,
                              editingIndex!,
                            );
                    } else if (noteController.text.isEmpty && editingMode) {
                      cancelEditingMode();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  AppBar defaultAppBar() {
    return AppBar(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(7),
        ),
      ),
      backgroundColor: const Color.fromRGBO(135, 148, 192, 1),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        color: const Color.fromRGBO(28, 33, 53, 1),
        onPressed: () => Navigator.pop(context),
      ),
      title: Expanded(
        child: Center(
          child: Text(
            event.title,
            style: const TextStyle(
              color: Color.fromRGBO(28, 33, 53, 1),
            ),
          ),
        ),
      ),
      actions: [
        Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(
                Icons.search_rounded,
                color: Color.fromRGBO(28, 33, 53, 1),
              ),
              onPressed: () {},
            );
          },
        ),
        Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(
                Icons.star_rounded,
                color: Color.fromRGBO(28, 33, 53, 1),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Favorites(
                    event: event,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  AppBar modeAppBar() {
    return AppBar(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(7),
        ),
      ),
      backgroundColor: const Color.fromRGBO(135, 148, 192, 1),
      leading: IconButton(
        icon: const Icon(Icons.cancel_rounded),
        color: const Color.fromRGBO(28, 33, 53, 1),
        onPressed: cancelSelectingMode,
      ),
      actions: [
        Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(
                Icons.copy_rounded,
                color: Color.fromRGBO(28, 33, 53, 1),
              ),
              onPressed: copyNotes,
            );
          },
        ),
        Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(
                Icons.star_rounded,
                color: Color.fromRGBO(28, 33, 53, 1),
              ),
              onPressed: addToFavorites,
            );
          },
        ),
        Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(
                Icons.delete_rounded,
                color: Color.fromRGBO(28, 33, 53, 1),
              ),
              onPressed: deleteNotes,
            );
          },
        ),
      ],
    );
  }

  Color? noteColor(int index) {
    if (event.notes[index].isSelected && selectingMode == true) {
      return Colors.lightGreen[200];
    }
    return (event.notes[index].rightHanded ? Colors.grey.shade200 : Colors.blue[200]);
  }

  void deleteNotes() {
    selected.sort();
    for (var i = selected.length - 1; i > -1; i--) {
      event.notes.removeAt(selected[i]);
    }
    setState(
      () {
        selectingMode = false;
        selected.clear();
      },
    );
  }

  void addToFavorites() {
    _changeMark(selected);
    cancelSelectingMode();
  }

  void copyNotes() {
    var copiedNotes = '';
    for (var index in selected) {
      copiedNotes += event.notes[index].content;
      copiedNotes += '\n';
    }
    Clipboard.setData(
      ClipboardData(
        text: copiedNotes,
      ),
    );
    cancelSelectingMode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (selectingMode) ? modeAppBar() : defaultAppBar(),
      body: Column(
        children: [
          if (event.notes.isEmpty) DefaultBody(title: event.title),
          if (event.notes.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: event.notes.length,
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: Container(
                      padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
                      child: Align(
                        alignment: (event.notes[index].rightHanded
                            ? Alignment.topLeft
                            : Alignment.topRight),
                        child: Container(
                          constraints: const BoxConstraints(
                            maxWidth: 200,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: noteColor(index),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.notes[index].content,
                                style: const TextStyle(fontSize: 15),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  (event.notes[index].isSelected)
                                      ? const Icon(
                                          Icons.check_rounded,
                                          size: 20,
                                          color: Colors.black,
                                        )
                                      : const SizedBox(
                                          width: 0.2,
                                        ),
                                  Text(
                                    event.notes[index].time,
                                    style: const TextStyle(fontSize: 11),
                                    textAlign: TextAlign.start,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  (event.notes[index].isFavorite)
                                      ? const Icon(
                                          Icons.star_rounded,
                                          size: 20,
                                          color: Color.fromRGBO(216, 205, 176, 0.9),
                                        )
                                      : const SizedBox(
                                          width: 0.2,
                                        ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    onLongPress: () => _editNote(index),
                    onDoubleTap: () => _changeMark([index]),
                    onTap: () => _selectingMode(index),
                  );
                },
              ),
            ),
          noteField(),
        ],
      ),
    );
  }
}
