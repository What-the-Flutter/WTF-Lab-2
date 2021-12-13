import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/event.dart';

class EventList extends StatefulWidget {
  static const routeName = '/events_route';

  EventList({Key? key}) : super(key: key);

  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  static const _accentColor = Color(0xff86BB8B);
  final _textInputController = TextEditingController();
  int _selectedIndex = -1;

  List<Event> _eventsList = [];
  List<Event> _favouriteEventsList = [];
  late String _title;
  late int _amountSelectedEvents;
  bool _validateText = false;
  bool _isFavouritesOn = false;

  String _aboutRoute =
      'Add your first event to this page by entering some text in the textbox below and hitting the send button. Long tap the send button to align the event in the opposite direction. Tap on the bookmark icon on the top right corner to show the bookmarked events only.';

  @override
  void dispose() {
    _textInputController.dispose();
    super.dispose();
  }

  void _addEvent() {
    if (_selectedIndex != -1) {
      if (_eventsList[_selectedIndex].isEditing == true) {
        _cofirmEditingEvent();
        return;
      }
    }
    setState(() {
      _textInputController.text.isEmpty
          ? _validateText = true
          : _validateText = false;
    });
    if (!_validateText) {
      var event = Event();
      event.content = _textInputController.text;
      _textInputController.clear();
      event.date = DateTime.now();
      _eventsList.add(event);
    }
  }

  void _editEvent() {
    setState(() {
      for (var item in _eventsList) {
        if (item.isSelected == true) {
          _textInputController.text = item.content;
          item.isEditing = true;
          print('${item.content} + ${item.isEditing}');
        }
      }
      _textInputController.selection = TextSelection.fromPosition(
          TextPosition(offset: _textInputController.text.length));
    });
  }

  void _removeEvent() {
    var indexes = [];
    for (var i = 0; i < _eventsList.length; i++) {
      if (_eventsList[i].isSelected) indexes.add(i);
    }

    for (var item in indexes.reversed) {
      _eventsList.removeAt(item);
    }
    setState(_countSelectedEvents);
    Navigator.pop(context);
  }

  void _copyEvent() {
    var data = '';
    for (var item in _eventsList) {
      if (item.isSelected) data += '${item.content}\n';
    }
    Clipboard.setData(ClipboardData(text: data));
    setState(() {
      for (var item in _eventsList) {
        item.isSelected = false;
      }
      _countSelectedEvents();
    });
  }

  bool _isEditing() {
    for (var item in _eventsList) {
      if (item.isEditing == true) return true;
    }
    return false;
  }

  String _getTimeFromDate(DateTime date) {
    return '${date.hour.toString()}:${date.minute.toString()}';
  }

  bool _isAnyItemSelected() {
    for (var item in _eventsList) {
      if (item.isSelected == true) return true;
    }
    return false;
  }

  void _countSelectedEvents() {
    var result = 0;
    for (var item in _eventsList) {
      if (item.isSelected == true) result++;
    }
    _amountSelectedEvents = result;
  }

  void _cofirmEditingEvent() {
    setState(() {
      _eventsList[_selectedIndex].content = _textInputController.text;
      _eventsList[_selectedIndex].isEditing = false;
      _eventsList[_selectedIndex].isEdited = true;
      _eventsList[_selectedIndex].isSelected = false;
      _textInputController.text = '';
    });
  }

  void _showFavourites() {
    setState(() {
      if (_isFavouritesOn) {
        _isFavouritesOn = false;
      } else {
        _isFavouritesOn = true;
      }

      if (_favouriteEventsList.isEmpty) return;
      var _temp = <Event>[];
      _temp = _eventsList;
      _eventsList = _favouriteEventsList;
      _favouriteEventsList = _temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    _title = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: _isAnyItemSelected() ? _optionsAppBar : _defAppBar,
      body: _routeBody,
      backgroundColor: Colors.blueGrey,
    );
  }

  AlertDialog get _deleteAlertDilog {
    return AlertDialog(
      title: const Text('Deleting events'),
      content: Text(
          'Are you sure you want to delete ${_amountSelectedEvents.toString()} selected events?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _removeEvent,
          child: const Text('OK'),
        ),
      ],
    );
  }

  AppBar get _optionsAppBar {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          setState(() {
            for (var item in _eventsList) {
              item.isSelected = false;
              item.isEditing = false;
            }
            _countSelectedEvents();
          });
        },
        icon: const Icon(
          Icons.cancel,
        ),
      ),
      title: Text(
        '$_amountSelectedEvents',
        textAlign: TextAlign.left,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      actions: [
        _isEditing()
            ? Row(
                children: [
                  IconButton(
                    onPressed: _cofirmEditingEvent,
                    icon: const Icon(
                      Icons.check,
                      size: 28,
                    ),
                  )
                ],
              )
            : Row(
                children: [
                  _amountSelectedEvents == 1
                      ? IconButton(
                          onPressed: _editEvent,
                          icon: const Icon(
                            Icons.edit,
                          ),
                        )
                      : Container(),
                  IconButton(
                    onPressed: _copyEvent,
                    icon: const Icon(
                      Icons.copy,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.favorite_outline,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (var context) => _deleteAlertDilog);
                    },
                    icon: const Icon(
                      Icons.delete,
                    ),
                  ),
                ],
              )
      ],
    );
  }

  AppBar get _defAppBar {
    return AppBar(
      centerTitle: true,
      title: Text(
        _title,
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20, color: Colors.amber[50]),
      ),
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: <Widget>[
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search),
        ),
        IconButton(
          onPressed: _showFavourites,
          icon: _isFavouritesOn
              ? const Icon(
                  Icons.favorite_rounded,
                  color: Color(0xffFC0A54),
                )
              : const Icon(Icons.favorite_outline),
        ),
      ],
    );
  }

  Widget get _routeBody {
    return Column(
      children: <Widget>[
        _eventsList.isNotEmpty ? _messagesWidget : _noMessageWidget,
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.bubble_chart,
                ),
              ),
              Expanded(
                child: SizedBox(
                  child: TextField(
                    minLines: 1,
                    onSubmitted: (var stub) {
                      _addEvent();
                    },
                    controller: _textInputController,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                      errorText: _validateText ? "Event can't be empty!" : null,
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent)),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      hintText: 'Type your events',
                      fillColor: const Color(0xffe5e5e5),
                      filled: true,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: _addEvent,
                icon: const Icon(
                  Icons.send,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget get _messagesWidget {
    return Expanded(
      child: ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  for (var item in _eventsList) {
                    if (item.isEditing) return;
                    if (item.isSelected == true) {
                      _eventsList[index].isSelected
                          ? _eventsList[index].isSelected = false
                          : _eventsList[index].isSelected = true;
                      _countSelectedEvents();
                      _selectedIndex = index;
                      return;
                    } else {
                      if (!_isFavouritesOn) {
                        if (_eventsList[index].isFavourite) {
                          _eventsList[index].isFavourite = false;
                          _favouriteEventsList.remove(_eventsList[index]);
                        } else {
                          _eventsList[index].isFavourite = true;
                          _favouriteEventsList.add(_eventsList[index]);
                        }
                        return;
                      }
                    }
                  }
                });
              },
              onLongPress: () {
                setState(() {
                  _eventsList[index].isSelected = true;
                  _selectedIndex = index;
                  _countSelectedEvents();
                });
                setState(() {});
              },
              /* child: Container(
                padding: const EdgeInsets.only(
                    left: 14, right: 46, top: 10, bottom: 10),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: _selectedIndex.contains(index)
                            ? const Color(0xff6b956f)
                            : _accentColor),
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      _eventsList[index].content,
                      style: const TextStyle(fontSize: 20),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ), */
              child: Container(
                padding: const EdgeInsets.only(
                    left: 14, right: 46, top: 6, bottom: 6),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(minWidth: 146),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _eventsList[index].isSelected
                                ? const Color(0xff6b956f)
                                : _accentColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.only(
                            top: 10,
                            right: 15,
                            left: 15,
                            bottom: 24,
                          ),
                          child: Text(
                            _eventsList[index].content,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text(
                              _getTimeFromDate(
                                _eventsList[index].date,
                              ),
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color(0xff4c4c4c),
                              ),
                            ),
                          ),
                          _eventsList[index].isFavourite
                              ? Container(
                                  height: 34,
                                  child: const Icon(
                                    Icons.favorite_rounded,
                                    size: 18,
                                    color: Color(0xffFC0A54),
                                  ),
                                  padding: const EdgeInsets.only(left: 6),
                                )
                              : Container(
                                  height: 34,
                                ),
                          _eventsList[index].isEdited
                              ? Container(
                                  height: 34,
                                  child: const Icon(Icons.edit, size: 18),
                                  padding: const EdgeInsets.only(left: 4),
                                )
                              : Container(
                                  height: 34,
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          itemCount: _eventsList.length),
    );
  }

  Widget get _noMessageWidget {
    return Expanded(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Container(
            decoration: BoxDecoration(
              color: _accentColor.withOpacity(0.8),
              borderRadius: BorderRadius.circular(15),
            ),
            height: 260,
            width: 330,
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                  'This is page where you can track everything about "$_title" !',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  child: Text(
                    '$_aboutRoute',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff323232),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  padding: const EdgeInsets.only(top: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
