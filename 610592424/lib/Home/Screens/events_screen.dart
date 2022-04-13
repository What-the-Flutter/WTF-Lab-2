import 'package:diploma/Home/Entities/event.dart';
import 'package:diploma/Home/Entities/event_holder.dart';
import 'package:diploma/Home/Additional/icons_set.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum States { normal, singleSelected, multiSelected, editing }

class EventsScreen extends StatefulWidget {
  final EventHolder eventHolder;

  const EventsScreen(this.eventHolder, {Key? key}) : super(key: key);

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Column(
        children: [
          Expanded(child: _eventsList()),
          Align(
            alignment: Alignment.bottomLeft,
            child: _bottomTextField(),
          ),
        ],
      ),
    );
  }

  States _currentState = States.normal;
  int? _tempEventId;

  bool _showImageList = false;

  final _keyForTextField = GlobalKey<FormFieldState<String>>();
  Icon? _chosenIcon;

  void _setState(States state) {
    setState(() {
      _currentState = state;
    });
  }

  void _setNormalState() {
    setState(() {
      _currentState = States.normal;
      _tempEventId = null;
      _chosenIcon = null;
      for (var element in widget.eventHolder.events) {
        element.isSelected = false;
      }
    });
  }

  void _setEditingState() {
    assert(_currentState == States.singleSelected);

    Event tempEvent = widget.eventHolder.events
        .firstWhere((element) => element.isSelected == true);

    setState(() {
      _tempEventId = tempEvent.id;
      _chosenIcon = tempEvent.icon;
      _currentState = States.editing;
    });
  }

  void _changePictureListVisibility() {
    setState(() {
      _showImageList = !_showImageList;
    });
  }

  void _changeEventSelection(Event event) {
    event.isSelected = !event.isSelected;
  }

  int _getItemsSelectedNumber() {
    return widget.eventHolder.events
        .where((element) => element.isSelected == true)
        .length;
  }

  void _setChosenIcon(Icon icon, [bool deleteIcon = false]) {
    setState(() {
      if (deleteIcon) {
        _chosenIcon = null;
      }
      else{
        _chosenIcon = icon;
      }

      _changePictureListVisibility();
    });
  }

  void _onEventTapOrPress(Event event) {
    if (_currentState == States.editing) {
      return;
    }

    _changeEventSelection(event);
    int itemsSelected = _getItemsSelectedNumber();

    setState(() {
      if (itemsSelected == 0) {
        _setNormalState();
      } else if (itemsSelected == 1) {
        _setState(States.singleSelected);
      } else {
        _setState(States.multiSelected);
      }
    });
  }

  void _editEvent() {
    assert(_tempEventId != null);
    assert(_currentState == States.editing);
    assert(_keyForTextField.currentState!.validate());

    Event _editedEvent = widget.eventHolder.events
        .firstWhere((element) => element.id == _tempEventId!);

    setState(() {
      _editedEvent.text = _keyForTextField.currentState!.value!;
      _editedEvent.icon = _chosenIcon;

      _setNormalState();
    });
  }

  void _addEvent() {
    assert(_currentState == States.normal);
    assert(_keyForTextField.currentState!.validate());

    setState(() {
      Event tempEvent;
      if (widget.eventHolder.events.isNotEmpty) {
        tempEvent = Event(widget.eventHolder.events.last.id + 1,
            _keyForTextField.currentState!.value!, _chosenIcon);
      } else {
        tempEvent =
            Event(0, _keyForTextField.currentState!.value!, _chosenIcon);
      }

      widget.eventHolder.events.add(tempEvent);

      _setNormalState();
    });
  }

  void _deleteAllSelected() {
    assert(_currentState == States.singleSelected ||
        _currentState == States.multiSelected);

    setState(() {
      widget.eventHolder.events
          .removeWhere((element) => element.isSelected == true);

      _setNormalState();
    });
  }

  void _copyAllSelected() {
    assert(_currentState == States.singleSelected ||
        _currentState == States.multiSelected);

    List<Event> events = widget.eventHolder.events
        .where((element) => element.isSelected == true)
        .toList();

    String _tempString = "";

    setState(() {
      for (var element in events) {
        _tempString += "${element.text} ";
        element.isSelected = true;
      }
      Clipboard.setData(ClipboardData(text: _tempString));

      _setNormalState();
    });
  }

  AppBar _appBar(BuildContext context) {
    switch (_currentState) {
      case States.normal:
        return AppBar(
          backgroundColor: Colors.green,
          leading: IconButton(
            ///добавить логику возврата на предыдущую страницу
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_outlined),
          ),
          title: Center(
            child: Text(widget.eventHolder.title),
          ),
          actions: const [
            IconButton(
              onPressed: null,
              icon: Icon(Icons.search_outlined),
            ),
            IconButton(
              onPressed: null,
              icon: Icon(Icons.bookmark_border_outlined),
            ),
          ],
        );
      case States.editing:
        return AppBar(
          backgroundColor: Colors.green,
          leading: IconButton(
              onPressed: () => _setNormalState(),
              icon: const Icon(Icons.close)),
          title: const Center(
            child: Text("Editing mode"),
          ),
        );
      case States.singleSelected:
        return AppBar(
          backgroundColor: Colors.green,
          leading: IconButton(
              onPressed: () => _setNormalState(),
              icon: const Icon(Icons.close)),
          actions: [
            IconButton(
              onPressed: () => _setEditingState(),
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () => _copyAllSelected(),
              icon: const Icon(Icons.content_copy_outlined),
            ),
            const IconButton(
              onPressed: null,
              icon: Icon(Icons.bookmark_border_outlined),
            ),
            IconButton(
              onPressed: () => _deleteAllSelected(),
              icon: const Icon(Icons.delete),
            ),
          ],
        );
      case States.multiSelected:
        return AppBar(
          backgroundColor: Colors.green,
          leading: IconButton(
              onPressed: () => _setNormalState(),
              icon: const Icon(Icons.close)),
          actions: [
            IconButton(
              onPressed: () => _copyAllSelected(),
              icon: const Icon(Icons.content_copy_outlined),
            ),
            const IconButton(
              onPressed: null,
              icon: Icon(Icons.bookmark_border_outlined),
            ),
            IconButton(
              onPressed: () => _deleteAllSelected(),
              icon: const Icon(Icons.delete),
            ),
          ],
        );
      default:
        throw Exception("wrong state");
    }
  }

  ListView _eventsList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.eventHolder.events.length,
      itemBuilder: (context, index) => Align(
        alignment: Alignment.bottomLeft,
        child: GestureDetector(
          onTap: () => _onEventTapOrPress(widget.eventHolder.events[index]),
          onLongPress: () =>
              _onEventTapOrPress(widget.eventHolder.events[index]),
          child: Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: widget.eventHolder.events[index].isSelected
                  ? Colors.amber.shade700
                  : Colors.amber,
            ),
            child: (widget.eventHolder.events[index].icon == null)
                ? Text(widget.eventHolder.events[index].text)
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      widget.eventHolder.events[index].icon!,
                      const SizedBox(height: 3),
                      Text(widget.eventHolder.events[index].text),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Column _bottomTextField() {
    switch(_currentState){
      case States.normal:
        return Column(
          children: [
            _showImageList
                ? Container(
              height: 120,
              padding: const EdgeInsets.all(7),
              child: _imageList(),
            )
                : Container(
              child: null,
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 5, 0, 5),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => _changePictureListVisibility(),
                    icon: (_chosenIcon == null)
                        ? const Icon(Icons.grain)
                        : _chosenIcon!,
                  ),
                  Expanded(
                    child: TextFormField(
                      key: _keyForTextField,
                      validator: (String? value) {
                        return (value == null || value.isEmpty)
                            ? "The value cannot be empty"
                            : null;
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () => _addEvent(),
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        );
      case States.editing:
        return Column(
          children: [
            _showImageList
                ? Container(
              height: 120,
              padding: const EdgeInsets.all(7),
              child: _imageList(),
            )
                : Container(
              child: null,
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 5, 0, 5),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => _changePictureListVisibility(),
                    icon: (_chosenIcon == null)
                        ? const Icon(Icons.grain)
                        : _chosenIcon!,
                  ),
                  Expanded(
                    child: TextFormField(
                      key: _keyForTextField,
                      initialValue: widget.eventHolder.events
                          .firstWhere((element) => element.id == _tempEventId!)
                          .text,
                      validator: (String? value) {
                        return (value == null || value.isEmpty)
                            ? "The value cannot be empty"
                            : null;
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () => _editEvent(),
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        );
      default:
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 5, 0, 5),
              color: Colors.grey,
              child: Row(
                children: [
                  Expanded(
                      child: TextFormField(
                        readOnly: true,
                      )),
                  const IconButton(
                    onPressed: null,
                    icon: Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        );
    }
  }

  ListView _imageList() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: mySetOfIcons.length,
      itemBuilder: (context, index) => Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: (index == 0) ? Colors.white : Colors.black54,
              ),
              child: IconButton(
                icon: mySetOfIcons[index],
                color: Colors.white,
                iconSize: 40,
                onPressed: () => _setChosenIcon(mySetOfIcons[index], index == 0),
              ),
            ),
            /*Text(mySetOfIcons[index].icon.toString(),
                style: const TextStyle(fontSize: 20)),*/
          ],
        ),
      ),
    );

    /*return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black54,
                ),
                child: const Icon(
                  Icons.event,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const Text("Event", style: TextStyle(fontSize: 20))
            ],
          ),
        ),
      ],
    );*/
  }
}
