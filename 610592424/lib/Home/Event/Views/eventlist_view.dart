import 'package:diploma/NewHome/Additional/theme_widget.dart';
import 'package:diploma/NewHome/Event/Assets/event_icons_set.dart';
import 'package:diploma/NewHome/Event/Cubit/eventslist_cubit.dart';
import 'package:diploma/NewHome/Event/Models/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum States { normal, singleSelected, multiSelected, editing, searching }

class EventListView extends StatefulWidget {
  const EventListView({Key? key}) : super(key: key);

  @override
  State<EventListView> createState() => _EventListViewState();
}

class _EventListViewState extends State<EventListView> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: GeneralTheme.of(context).myTheme.themeData,
      child: Scaffold(
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
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    context.read<EventListCubit>().deselectAllEvents();
  }

  States _currentState = States.normal;
  int? _tempEventId;

  bool _showImageList = false;

  final _keyForTextField = GlobalKey<FormFieldState<String>>();
  Icon? _chosenIcon;

  void _setState(States state) => setState(() {
        _currentState = state;
      });

  void _setNormalState() {
    setState(() {
      _currentState = States.normal;
      _tempEventId = null;
      _chosenIcon = null;
      context.read<EventListCubit>().deselectAllEvents();
    });
  }

  void _setEditingState() {
    assert(_currentState == States.singleSelected);

    Event tempEvent = context.read<EventListCubit>().getSingleSelected();

    setState(() {
      _tempEventId = tempEvent.id;
      _chosenIcon = tempEvent.icon;
      _currentState = States.editing;
    });
  }

  void _setSearchingState(){
    _setState(States.searching);
    _applySearch("");
  }

  void _changePictureListVisibility() => setState(() {
        _showImageList = !_showImageList;
      });

  void _setChosenIcon(Icon icon, [bool deleteIcon = false]) {
    setState(() {
      if (deleteIcon) {
        _chosenIcon = null;
      } else {
        _chosenIcon = icon;
      }

      _changePictureListVisibility();
    });
  }

  void _onEventTapOrPress(Event event) {
    if (_currentState == States.editing) {
      return;
    }

    context.read<EventListCubit>().changeEventSelection(event.id);

    var itemsSelected = context.read<EventListCubit>().eventsSelected;

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

    var _newEvent = Event(
      _tempEventId!,
      _keyForTextField.currentState!.value!,
      _chosenIcon,
    );

    context.read<EventListCubit>().editEvent(_newEvent);

    _setNormalState();
  }

  void _addEvent() {
    assert(_currentState == States.normal);
    assert(_keyForTextField.currentState!.validate());

    Event tempEvent = Event(
      -1,
      _keyForTextField.currentState!.value!,
      _chosenIcon,
    );

    context.read<EventListCubit>().addEvent(tempEvent);
  }

  void _copyAllSelected() {
    context.read<EventListCubit>().copyAllSelected();
    _setNormalState();
  }

  void _deleteAllSelected() {
    context.read<EventListCubit>().deleteAllSelected();
    _setNormalState();
  }

  void _applySearch(String text){
    context.read<EventListCubit>().applySearch(text);
  }

  AppBar _appBar(BuildContext context) {
    switch (_currentState) {
      case States.normal:
        return AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_outlined),
          ),
          title: Center(
            child: Text(context.read<EventListCubit>().eventHolderTitle),
          ),
          actions: [
            IconButton(
              onPressed: () => _setSearchingState(),
              icon: const Icon(Icons.search_outlined),
            ),
            const IconButton(
              onPressed: null,
              icon: Icon(Icons.bookmark_border_outlined),
            ),
          ],
        );
      case States.editing:
        return AppBar(
          leading: IconButton(
            onPressed: () => _setNormalState(),
            icon: const Icon(Icons.close),
          ),
          title: const Center(
            child: Text("Editing mode"),
          ),
        );
      case States.singleSelected:
        return AppBar(
          leading: IconButton(
            onPressed: () => _setNormalState(),
            icon: const Icon(Icons.close),
          ),
          actions: [
            IconButton(
              onPressed: () => _setEditingState(),
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () => _copyAllSelected(),
              icon: const Icon(Icons.content_copy_outlined),
            ),
            IconButton(
              onPressed: () => _forwardAllSelected(context)
                  .then((value) => _setNormalState()),
              icon: const Icon(Icons.shortcut_outlined),
            ),
            IconButton(
              onPressed: () => _deleteAllSelected(),
              icon: const Icon(Icons.delete),
            ),
          ],
        );
      case States.multiSelected:
        return AppBar(
          leading: IconButton(
            onPressed: () => _setNormalState(),
            icon: const Icon(Icons.close),
          ),
          actions: [
            IconButton(
              onPressed: () => _copyAllSelected(),
              icon: const Icon(Icons.content_copy_outlined),
            ),
            IconButton(
              onPressed: () => _forwardAllSelected(context)
                  .then((value) => _setNormalState()),
              icon: const Icon(Icons.shortcut_outlined),
            ),
            IconButton(
              onPressed: () => _deleteAllSelected(),
              icon: const Icon(Icons.delete),
            ),
          ],
        );
      case States.searching:
        return AppBar(
          leading: IconButton(
            onPressed: () => _setNormalState(),
            icon: const Icon(Icons.close),
          ),
          title: TextFormField(
            cursorColor: Colors.red,
            autofocus: false,
            onChanged: (text) => _applySearch(text),
          ),
        );
      default:
        throw Exception("wrong state");
    }
  }

  BlocBuilder _eventsList() {
    return BlocBuilder<EventListCubit, List<Event>>(builder: (context, state) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: state.length,
        itemBuilder: (context, index) => Align(
          alignment: Alignment.bottomLeft,
          child: GestureDetector(
            onTap: () => _onEventTapOrPress(state[index]),
            onLongPress: () => _onEventTapOrPress(state[index]),
            child: Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: state[index].isSelected
                    ? Colors.amber.shade700
                    : Colors.amber,
              ),
              child: (state[index].icon == null)
                  ? Text(state[index].text)
                  : Column(
                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        state[index].icon!,
                        const SizedBox(
                          height: 3,
                          width: 1,
                        ),
                        Text(state[index].text),
                      ],
                    ),
            ),
          ),
        ),
      );
    });
  }

  Column _bottomTextField() {
    switch (_currentState) {
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
                      initialValue: context
                          .read<EventListCubit>()
                          .getEvent(_tempEventId!)
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
      case States.searching:
        return Column();
      default:
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 5, 0, 5),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      initialValue: "Choose events",
                    ),
                  ),
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
      itemCount: setOfEventIcons.length,
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
                icon: setOfEventIcons[index],
                color: Colors.white,
                iconSize: 40,
                onPressed: () =>
                    _setChosenIcon(setOfEventIcons[index], index == 0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _forwardAllSelected(BuildContext myContext) async {
    return await showDialog(
      context: myContext,
      barrierDismissible: true,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Choose page'),
          children: [
            for (var eventHolder
                in myContext.read<EventListCubit>().getEventForwardingHoldersList())
              SimpleDialogOption(
                onPressed: () {
                  myContext
                      .read<EventListCubit>()
                      .forwardAllSelected(eventHolder.id);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(eventHolder.picture.icon),
                    Text(eventHolder.title),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
