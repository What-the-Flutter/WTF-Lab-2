import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/event.dart';
import '../../models/page.dart';
import 'app_bars/default_appbar.dart';
import 'app_bars/selected_event_appbar.dart';
import 'const_widgets.dart';
import 'event_listtile.dart';
import 'no_events_widget.dart';
import 'textfiled_widget.dart';

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

  List<Event> _eventsList = [];
  List<Event> _favouriteEventsList = [];
  late PageInfo _parentPage;
  int _amountSelectedEvents = 0;
  bool _validateText = false;
  bool _isFavouritesOn = false;
  int _selectedIndex = -1;

  final String _aboutRoute =
      'Add your first event to this page by entering some text in the textbox '
      'below and hitting the send button. Long tap the send button to align '
      'the event in the opposite direction. Tap on the bookmark icon on the '
      'top right corner to show the bookmarked events only.';

  void _addEvent(int index) {
    if (index != -1) {
      if (_eventsList[index].isEditing == true) {
        _confirmEditingEvent(index);
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

  String _getTimeFromDate(DateTime date) =>
      '${date.hour.toString()}:${date.minute.toString()}';

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

  void _confirmEditingEvent(int index) {
    _eventsList[index].content = _textInputController.text;
    _eventsList[index].isEditing = false;
    _eventsList[index].isEdited = true;
    _eventsList[index].isSelected = false;
    _textInputController.text = '';
    _countSelectedEvents();
    setState(() {});
  }

  void _getOneSelectedEvent() {
    var counter = 0;
    for (var item in _eventsList) {
      if (item.isSelected == true) {
        _confirmEditingEvent(counter);
        return;
      }
      counter++;
    }
  }

  void _showFavourites() {
    setState(() {
      (_isFavouritesOn) ? _isFavouritesOn = false : _isFavouritesOn = true;

      if (_favouriteEventsList.isEmpty) return;
      _favouriteEventsList.sort((a, b) => a.date.compareTo(b.date));
      var _temp = <Event>[];
      _temp = _eventsList;
      _eventsList = _favouriteEventsList;
      _favouriteEventsList = _temp;
    });
  }

  void _eventTap(int index) {
    _selectedIndex = index;
    if (_amountSelectedEvents > 0) {
      _eventsList[index].isSelected
          ? _eventsList[index].isSelected = false
          : _eventsList[index].isSelected = true;
      setState(_countSelectedEvents);
    } else {
      if (_eventsList[index].isFavourite) {
        _favouriteEventsList.remove(_eventsList[index]);
        _eventsList[index].isFavourite = false;
      } else {
        _favouriteEventsList.add(_eventsList[index]);
        _eventsList[index].isFavourite = true;
      }
      setState(_countSelectedEvents);
    }
  }

  void _cancelRemovingEvents() => Navigator.pop(context);

  void _cancelClick() {
    for (var item in _eventsList) {
      item.isSelected = false;
      item.isEditing = false;
    }
    _countSelectedEvents();
    setState(() {});
  }

  void _backButtonClick() {
    if (_eventsList.isNotEmpty) {
      _parentPage.eventList = _eventsList;
      _parentPage.favEventsList = _favouriteEventsList;
      _parentPage.lastEditTime = _parentPage.eventList.last.date;
    }
    Navigator.pop(context, _parentPage);
  }

  @override
  Widget build(BuildContext context) {
    _parentPage = ModalRoute.of(context)!.settings.arguments as PageInfo;
    EventList.title = _parentPage.title;
    if (_parentPage.eventList.isNotEmpty && _isFavouritesOn == false) {
      _eventsList = _parentPage.eventList;
    }
    if (_parentPage.favEventsList.isNotEmpty) {
      _favouriteEventsList = _parentPage.favEventsList;
    }

    return MaterialApp(
      home: Scaffold(
        appBar: _isAnyItemSelected()
            ? EventSelectedAppBar(
                amountSelectedEvents: _amountSelectedEvents,
                eventsList: _eventsList,
                countSelectedEvents: _countSelectedEvents,
                removeEvent: _removeEvent,
                getSelectedItem: _getOneSelectedEvent,
                copyEvent: _copyEvent,
                editEvent: _editEvent,
                isEditing: _isEditing,
                cancelClick: _cancelClick,
                cancelRemoving: _cancelRemovingEvents,
              )
            : DefaultAppBar(
                backButtonClick: _backButtonClick,
                showFavourites: _showFavourites,
                isFavouritesOn: _isFavouritesOn,
              ),
        body: _routeBody,
        backgroundColor: Colors.blueGrey,
      ),
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
                onPressed: () => _addEvent(_eventsList.length - 1),
                icon: iconSendEvent,
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget get _textFieldInput {
    return CustomTextField(
      onSubmitted: () => _addEvent(_eventsList.length - 1),
      controller: _textInputController,
      validateText: _validateText,
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
          return EventListTile(
            index: index,
            getTimeFromDate: _getTimeFromDate,
            eventList: _eventsList,
            onTap: _eventTap,
            countSelectedEvents: _countSelectedEvents,
            setState: setState,
            selectedIndex: _selectedIndex,
          );
        },
        itemCount: _eventsList.length,
      ),
    );
  }
}
