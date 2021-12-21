import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/event.dart';
import '../../models/page.dart';
import '../../styles.dart';
import 'const_widgets.dart';
import 'stateless_widgets_events_page.dart';

class EventList extends StatefulWidget {
  static const routeName = '/events_route';

  EventList({Key? key}) : super(key: key);
  static String title = '';

  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  static const _accentColor = Color(0xff86BB8B);
  final _textInputController = TextEditingController();
  int _selectedIndex = -1;

  List<Event> _eventsList = [];
  List<Event> _favouriteEventsList = [];
  late PageInfo _parentPage;
  int _amountSelectedEvents = 0;
  bool _validateText = false;
  bool _isFavouritesOn = false;

  final String _aboutRoute =
      'Add your first event to this page by entering some text in the textbox below and hitting the send button. Long tap the send button to align the event in the opposite direction. Tap on the bookmark icon on the top right corner to show the bookmarked events only.';

  void _addEvent() {
    if (_selectedIndex != -1) {
      if (_eventsList[_selectedIndex].isEditing == true) {
        _confirmEditingEvent();
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
        }
      }
      _textInputController.selection = TextSelection.fromPosition(
        TextPosition(offset: _textInputController.text.length),
      );
    });
  }

  void _removeEvent() {
    setState(() {
      var indexes = [];
      for (var i = 0; i < _eventsList.length; i++) {
        if (_eventsList[i].isSelected) indexes.add(i);
      }

      for (var item in indexes.reversed) {
        _eventsList.removeAt(item);
      }
      Navigator.pop(context);
      setState(_countSelectedEvents);
      _selectedIndex = -1;
    });
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
    result == 0 ? _amountSelectedEvents = -1 : _amountSelectedEvents = result;
  }

  void _confirmEditingEvent() {
    setState(() {
      _eventsList[_selectedIndex].content = _textInputController.text;
      _eventsList[_selectedIndex].isEditing = false;
      _eventsList[_selectedIndex].isEdited = true;
      _eventsList[_selectedIndex].isSelected = false;
      _textInputController.text = '';
      _countSelectedEvents();
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
      _favouriteEventsList.sort((a, b) => a.date.compareTo(b.date));
      var _temp = <Event>[];
      _temp = _eventsList;
      _eventsList = _favouriteEventsList;
      _favouriteEventsList = _temp;
    });
  }

  void _eventTap(int index) {
    if (_amountSelectedEvents > 0) {
      _eventsList[index].isSelected
          ? _eventsList[index].isSelected = false
          : _eventsList[index].isSelected = true;
    } else {
      if (_eventsList[index].isFavourite) {
        _favouriteEventsList.remove(_eventsList[index]);
        _eventsList[index].isFavourite = false;
      } else {
        _favouriteEventsList.add(_eventsList[index]);
        _eventsList[index].isFavourite = true;
      }
    }
  }

  void _backButton() {
    if (_eventsList.isEmpty) {
      Navigator.pop(context, _parentPage);
    }
    _parentPage.eventList = _eventsList;
    _parentPage.lastEditTime = _parentPage.eventList.last.date;
    Navigator.pop(context, _parentPage);
  }

  @override
  Widget build(BuildContext context) {
    _parentPage = ModalRoute.of(context)!.settings.arguments as PageInfo;
    EventList.title = _parentPage.title;
    if (_parentPage.eventList.isNotEmpty && _isFavouritesOn == false) {
      _eventsList = _parentPage.eventList;
    }

    return MaterialApp(
      home: Scaffold(
        appBar: _isAnyItemSelected() ? _eventSelectedAppBar : _defaultAppBar,
        body: _routeBody,
        backgroundColor: Colors.blueGrey,
      ),
    );
  }

  AlertDialog get _deleteAlertDilog {
    return AlertDialog(
      title: const Text('Deleting events'),
      content: Text(
        'Are you sure you want to delete ${_amountSelectedEvents.toString()} selected events?',
      ),
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

  AppBar get _eventSelectedAppBar {
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
        icon: iconCancel,
      ),
      title: Text(
        '$_amountSelectedEvents',
        textAlign: TextAlign.left,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      actions: [
        _isEditing()
            ? _eventEditingAppBarOptions
            : _eventsNotEditingAppBarOptions
      ],
    );
  }

  Row get _eventsNotEditingAppBarOptions {
    return Row(
      children: [
        _amountSelectedEvents == 1
            ? IconButton(
                onPressed: _editEvent,
                icon: iconEdit,
              )
            : Container(),
        IconButton(
          onPressed: _copyEvent,
          icon: iconCopy,
        ),
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (var context) => _deleteAlertDilog,
            );
          },
          icon: iconDelete,
        ),
      ],
    );
  }

  Row get _eventEditingAppBarOptions {
    return Row(
      children: [
        IconButton(
          onPressed: _confirmEditingEvent,
          icon: iconCheck,
        )
      ],
    );
  }

  AppBar get _defaultAppBar {
    return AppBar(
      backgroundColor: Colors.indigo,
      centerTitle: true,
      title: Text(
        EventList.title,
        style: titlePageStyle,
      ),
      leading: IconButton(
        icon: iconArrowBack,
        onPressed: _backButton,
      ),
      actions: <Widget>[
        IconButton(
          onPressed: () {},
          icon: iconSearch,
        ),
        IconButton(
          onPressed: _showFavourites,
          icon: _isFavouritesOn ? favouriteIcon : favouriteIconOutlined,
        ),
      ],
    );
  }

  Widget get _routeBody {
    return Column(
      children: <Widget>[
        _eventsList.isNotEmpty ? _messagesWidget : const NoEventsWidget(),
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: () {},
                icon: iconBubbleChart,
              ),
              Expanded(
                child: SizedBox(
                  child: _textFieldInput,
                ),
              ),
              IconButton(
                onPressed: _addEvent,
                icon: iconSendEvent,
              ),
            ],
          ),
        )
      ],
    );
  }

  TextField get _textFieldInput {
    return TextField(
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
        errorStyle: inputErrorStyle,
        enabledBorder: borderStyle,
        focusedBorder: borderStyle,
        hintText: 'Type your events',
        fillColor: const Color(0xffe5e5e5),
        filled: true,
      ),
    );
  }

  Widget get _messagesWidget {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.only(
          top: 10,
          bottom: 10,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _eventTap(index);
              setState(_countSelectedEvents);
            },
            onLongPress: () {
              setState(() {
                _eventsList[index].isSelected = true;
                _selectedIndex = index;
                _countSelectedEvents();
              });
            },
            child: Container(
              padding: const EdgeInsets.only(
                left: 14,
                right: 46,
                top: 6,
                bottom: 6,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    _eventLayout(index),
                    _eventModificatorsLayout(index),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: _eventsList.length,
      ),
    );
  }

  Widget _eventLayout(int index) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 106,
      ),
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
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _eventModificatorsLayout(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            _getTimeFromDate(
              _eventsList[index].date,
            ),
            style: eventTimeStyle,
          ),
        ),
        _eventsList[index].isFavourite ? eventFavourite : emptyContainer,
        _eventsList[index].isEdited ? eventEdited : emptyContainer,
      ],
    );
  }
}
