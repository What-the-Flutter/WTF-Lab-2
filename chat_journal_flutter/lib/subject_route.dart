import 'package:flutter/material.dart';
import '../models/event.dart';
import 'package:flutter/services.dart';

class EventList extends StatefulWidget {
  static const routeName = '/events_route';

  EventList({Key? key}) : super(key: key);

  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  static const _accentColor = Color(0xff86BB8B);
  final _textInputController = TextEditingController();

  final List<Event> _eventsList = [];
  late String _title;
  final Set<int> _selectedIndex = {};
  late int _amountSelectedEvents;
  bool _validateText = false;

  @override
  void dispose() {
    _textInputController.dispose();
    super.dispose();
  }

  void _addEvent() {
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

  @override
  Widget build(BuildContext context) {
    print(_countSelectedEvents);
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
            }
            _countSelectedEvents();
          });
        },
        icon: const Icon(
          Icons.cancel,
        ),
      ),
      actions: [
        Padding(
          child: Text(
            '$_amountSelectedEvents',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          padding: const EdgeInsets.only(right: 100, top: 16),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.edit,
              ),
            ),
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
          onPressed: () {},
          icon: const Icon(Icons.favorite_outline),
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
                  /*   if (_selectedIndex.isNotEmpty) {
                    _selectedIndex.contains(index)
                        ? _selectedIndex.remove(index)
                        : _selectedIndex.add(index);
                  } */
                  for (var item in _eventsList) {
                    if (item.isSelected == true) {
                      _eventsList[index].isSelected
                          ? _eventsList[index].isSelected = false
                          : _eventsList[index].isSelected = true;
                      _countSelectedEvents();

                      return;
                    }
                  }
                });
              },
              onLongPress: () {
                setState(() {
                  _eventsList[index].isSelected = true;
                  _selectedIndex.add(index);
                  _countSelectedEvents();
                });
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
                    left: 14, right: 46, top: 10, bottom: 10),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
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
                          bottom: 10,
                        ),
                        child: Text(
                          _eventsList[index].content,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ],
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
                    "Add your first event to '$_title' page by entering some text in the textbox below and hitting the send button. Long tap the send button to align the event in the opposite direction. Tap on the bookmark icon on the top right corner to show the bookmarked events only.",
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
