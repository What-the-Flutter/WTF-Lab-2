import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_bars/default_app_bar.dart';
import 'app_bars/edit_mode_app_bar.dart';
import 'data/event.dart';

import 'event_list.dart';
import 'without_event.dart';

class EventDialog extends StatefulWidget {
  final String titleTask;

  const EventDialog({Key? key, required this.titleTask}) : super(key: key);

  @override
  _EventDialogState createState() => _EventDialogState(titleTask);
}

class _EventDialogState extends State<EventDialog> {
  TextEditingController editingController = TextEditingController();
  bool textIsEmpty = true;
  bool isBookMarkPage = false;
  int numberOfSelectedItem = 0;
  List<int> tappedEventIndex = [];

  final String title;
  List<Event> _eventsList = [
    Event('Drink water', DateTime.now()),
    Event('Do Flutter', DateTime.now()),
  ];

  List<Event> _favouriteEventsList = [];

  IconButton _iconButtonChange() {
    return textIsEmpty
        ? const IconButton(
            icon: Icon(
              Icons.add_a_photo_outlined,
            ),
            onPressed: null,
          )
        : IconButton(
            icon: const Icon(
              Icons.send,
            ),
            onPressed: () {
              tappedEventIndex.isNotEmpty
                  ? _finalEditing(tappedEventIndex.last)
                  : _createNewEvent();
            },
          );
  }

  _EventDialogState(this.title) : super();

  Widget _eventExist() {
    return ListView.builder(
      itemCount: _eventsList.length,
      itemBuilder: (context, index) {
        return EventTile(
          index: index,
          eventsList: _eventsList,
          onTap: _setToBookMark,
          onPressed: _selectElement,
          getTime: _getTimeFromDate,
        );
      },
      shrinkWrap: true,
    );
  }

  void _selectElement(int index) {
    setState(
      () {
        _eventsList[index].isSelected
            ? _eventsList[index].isSelected = false
            : _eventsList[index].isSelected = true;

        if (_eventsList[index].isSelected == true) {
          numberOfSelectedItem++;
          tappedEventIndex.add(index);
        } else {
          numberOfSelectedItem--;
          tappedEventIndex.remove(index);
        }
      },
    );
  }

  String _getTimeFromDate(DateTime date) {
    return '${date.hour}.${date.minute}';
  }

  void _closeEditMode() {
    setState(
      () {
        _eventsList.forEach(
          (element) {
            element.isSelected = false;
          },
        );
        numberOfSelectedItem = 0;
        editingController.text = '';
        tappedEventIndex = [];
      },
    );
  }

  void _copyEvent(int index) {
    Clipboard.setData(ClipboardData(text: _eventsList[index].content));
  }

  bool _isEditable() {
    return _eventsList.any((element) => element.isSelected == true);
  }

  void _backToPreviousScreen() => Navigator.pop(context);

  void _createNewEvent() {
    if (editingController.value.text != '') {
      setState(
        () {
          var newEvent = Event(editingController.value.text, DateTime.now());
          _eventsList.add(newEvent);
          editingController.text = '';
        },
      );
    }
  }

  void _editEvent() {
    setState(
      () {
        for (var item in _eventsList) {
          if (item.isSelected) {
            editingController.text = item.content;
          }
        }
      },
    );
  }

  void _finalEditing(int index) {
    _eventsList[index].content = editingController.text;
    _eventsList[index].isEdited = true;
    _closeEditMode();
    setState(() {});
  }

  void _deleteEvent(int index) {
    setState(
      () {
        _eventsList.removeAt(index);
      },
    );
    _closeEditMode();
  }

  void _setToBookMark(int index) {
    setState(() {
      if (_eventsList[index].inBookMarks) {
        _favouriteEventsList.remove(_eventsList[index]);
        _eventsList[index].inBookMarks = false;
      } else {
        _favouriteEventsList.add(_eventsList[index]);
        _eventsList[index].inBookMarks = true;
      }
    });
  }

  void _screenBookMarks() {
    setState(
      () {
        isBookMarkPage = !isBookMarkPage;
        if (_favouriteEventsList.isEmpty) {
          return;
        } else {
          var _temp = <Event>[];
          _temp = _eventsList;
          _eventsList = _favouriteEventsList;
          _favouriteEventsList = _temp;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: _isEditable()
          ? EditModeAppBar(
              index: tappedEventIndex.last,
              chosenForEditEvent: numberOfSelectedItem,
              copy: _copyEvent,
              editionStart: _editEvent,
              editionConfirm: _finalEditing,
              delete: _deleteEvent,
              close: _closeEditMode,
            )
          : DefaultAppBar(
              title: title,
              backToPreviousScreen: _backToPreviousScreen,
              screenBookMark: _screenBookMarks,
            ),
      body: Column(
        children: [
          _eventsList.isNotEmpty
              ? Expanded(
                  child: _eventExist(),
                )
              : WithoutEvent(nameTask: title),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const IconButton(
                  icon: Icon(Icons.apps_outlined),
                  onPressed: null,
                ),
                Expanded(
                  child: TextField(
                    controller: editingController,
                    onChanged: (value) async {
                      setState(() {
                        if (value.isNotEmpty) {
                          textIsEmpty = false;
                        } else {
                          textIsEmpty = true;
                        }
                      });
                    },
                    decoration:
                        const InputDecoration(border: OutlineInputBorder()),
                  ),
                ),
                _iconButtonChange(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
