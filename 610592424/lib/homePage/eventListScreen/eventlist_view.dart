import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashtagable/hashtagable.dart';
import 'package:intl/intl.dart';

import 'package:diploma/homePage/assets/event_icons_set.dart';
import 'package:diploma/homePage/models/event.dart';
import '../settings_screen/settings_cubit.dart';
import './cubit/eventlist_cubit.dart';
import './cubit/eventlist_state.dart';

enum States { normal, singleSelected, multiSelected, editing, searching }

class EventListView extends StatefulWidget {
  final String title;

  const EventListView(this.title, {Key? key}) : super(key: key);

  @override
  State<EventListView> createState() => _EventListViewState();
}

class _EventListViewState extends State<EventListView> {
  var _currentState = States.normal;
  int? _tempEventId;
  var _showImageList = false;
  final _keyForTextField = GlobalKey<FormFieldState<String>>();
  var _chosenIconIndex = 0;
  var _allowImagePick = true;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<EventListCubit>(context).init();
  }

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

  void _setAllowImagePick(String text) {
    setState(() {
      _allowImagePick = text.isEmpty;
    });
  }

  void _setState(States state) => setState(() {
        _currentState = state;
      });

  void _setNormalState() {
    setState(() {
      _currentState = States.normal;
      _tempEventId = null;
      _chosenIconIndex = 0;
      context.read<EventListCubit>().deselectAllEvents();
    });
    BlocProvider.of<EventListCubit>(context).init();
  }

  void _setEditingState() {
    assert(_currentState == States.singleSelected);

    Event tempEvent = context.read<EventListCubit>().getSingleSelected();

    setState(() {
      _tempEventId = tempEvent.eventId;
      _chosenIconIndex = tempEvent.iconIndex ?? 0;
      _currentState = States.editing;
    });
  }

  void _setSearchingState() {
    _setState(States.searching);
    _applySearch("");
  }

  void _changePictureListVisibility() => setState(() {
        _showImageList = !_showImageList;
      });

  void _setChosenIcon(int iconIndex) {
    setState(() {
      _chosenIconIndex = iconIndex;

      _changePictureListVisibility();
    });
  }

  void _onEventTapOrPress(Event event) {
    if (_currentState == States.editing) {
      return;
    }

    context.read<EventListCubit>().changeEventSelection(event.eventId);

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
      -1,
      _chosenIconIndex == 0 ? null : _chosenIconIndex,
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
      -1,
      _chosenIconIndex == 0 ? null : _chosenIconIndex,
    );

    context.read<EventListCubit>().addEvent(tempEvent);

    _setNormalState();
  }

  void _copyAllSelected() {
    context.read<EventListCubit>().copyAllSelected();
    _setNormalState();
  }

  void _deleteAllSelected() {
    context.read<EventListCubit>().deleteAllSelected();
    _setNormalState();
  }

  void _applySearch(String text) {
    context.read<EventListCubit>().applySearch(text);
  }

  AppBar _appBar(BuildContext context) {
    switch (_currentState) {
      case States.normal:
        return AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_outlined),
          ),
          title: Center(
            child: Text(widget.title),
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
          backgroundColor: Theme.of(context).primaryColor,
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
          backgroundColor: Theme.of(context).primaryColor,
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
          backgroundColor: Theme.of(context).primaryColor,
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
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
            onPressed: () => _setNormalState(),
            icon: const Icon(Icons.close),
          ),
          title: TextFormField(
            cursorColor: Colors.red,
            autofocus: false,
            onChanged: (text) => _applySearch(text),
          ),
          bottom: _getAppbarBottom(),
        );
      default:
        throw Exception("wrong state");
    }
  }

  PreferredSizeWidget? _getAppbarBottom() {
    return BlocProvider.of<EventListCubit>(context).state.anyHashtags
        ? PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 60.0),
              child: FutureBuilder(
                  future:
                      BlocProvider.of<EventListCubit>(context).getAllHashTags(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<String>> snapshot) {
                    if (snapshot.hasData) {
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () => _applySearch(snapshot.data![index]),
                            child: Container(
                              margin: const EdgeInsets.all(3),
                              padding: const EdgeInsets.all(8),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.blueGrey,
                              ),
                              child: Text(snapshot.data![index]),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  }),
            ),
          )
        : null;
  }

  BlocBuilder _eventsList() {
    var _eventAlignment =
    BlocProvider.of<SettingsCubit>(context).state.bubbleAlignment
        ? Alignment.bottomRight
        : Alignment.bottomLeft;
    return BlocBuilder<EventListCubit, EventListState>(
      builder: (context, state) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: state.events.length,
          itemBuilder: (context, index) {
            var _showDate = index != 0 &&
                state.events[index].timeOfCreation!
                        .difference(state.events[index - 1].timeOfCreation!)
                        .inDays >= 1;
            if (index == 0 || _showDate) {
              return Column(
                children: [
                  Align(
                    alignment:
                        BlocProvider.of<SettingsCubit>(context).state.centerDate
                            ? Alignment.bottomCenter
                            : _eventAlignment,
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.redAccent,
                        border: Border.all(width: 2, color: Colors.black45),
                      ),
                      child: Text(
                        DateFormat("MM.dd")
                            .format(state.events[index].timeOfCreation!),
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                  ),
                  _showEvent(state, index, _eventAlignment),
                ],
              );
            }
            return _showEvent(state, index, _eventAlignment);
          },
        );
      },
    );
  }

  Align _showEvent(EventListState state, int index, Alignment alignment) {
    return Align(
      alignment: alignment,
      child: GestureDetector(
        onTap: () => _onEventTapOrPress(state.events[index]),
        onLongPress: () => _onEventTapOrPress(state.events[index]),
        child: Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: state.events[index].isSelected
                ? Colors.amber.shade700
                : Colors.amber,
          ),
          child: state.events[index].imagePath == null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (state.events[index].icon != null)
                        ? Container(
                            margin: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                            child: state.events[index].icon!,
                          )
                        : const SizedBox.shrink(),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 130),
                      child: HashTagText(
                        text: state.events[index].text,
                        basicStyle: Theme.of(context).textTheme.bodyText1!,
                        decoratedStyle: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize:
                              Theme.of(context).textTheme.bodyText1!.fontSize,
                        ),
                      ),
                    ),
                    Text(
                      DateFormat('Hm')
                          .format(state.events[index].timeOfCreation!),
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                )
              : FutureBuilder(
                  future: BlocProvider.of<EventListCubit>(context)
                      .fetchImage(state.events[index].eventId),
                  builder:
                      (BuildContext context, AsyncSnapshot<Image> snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            constraints: const BoxConstraints(
                              minHeight: 5.0,
                              minWidth: 5.0,
                              maxHeight: 300.0,
                              maxWidth: 300.0,
                            ),
                            child: snapshot.data!,
                          ),
                          Text(
                            '${state.events[index].timeOfCreation!.hour}:${state.events[index].timeOfCreation!.minute}',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return const Text('error occurred');
                    } else {
                      return const SizedBox(
                        width: 200,
                        height: 200,
                        child: Center(
                          child: Text('loading...'),
                        ),
                      );
                    }
                  },
                ),
        ),
      ),
    );
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
                    icon: (_chosenIconIndex == 0)
                        ? const Icon(Icons.grain)
                        : setOfEventIcons[_chosenIconIndex],
                  ),
                  Expanded(
                    child: TextFormField(
                      key: _keyForTextField,
                      initialValue: '',
                      validator: (String? value) {
                        return (value == null || value.isEmpty)
                            ? "The value cannot be empty"
                            : null;
                      },
                      onChanged: (text) => _setAllowImagePick(text),
                    ),
                  ),
                  _allowImagePick
                      ? IconButton(
                          onPressed: () async {
                            await BlocProvider.of<EventListCubit>(context)
                                .attachImage();
                            BlocProvider.of<EventListCubit>(context).init();
                          },
                          icon: const Icon(Icons.image),
                        )
                      : IconButton(
                          onPressed: () {
                            _addEvent();
                            _keyForTextField.currentState!.reset();
                          },
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
                    icon: (_chosenIconIndex == 0)
                        ? const Icon(Icons.grain)
                        : setOfEventIcons[_chosenIconIndex],
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
                    onPressed: () {
                      _editEvent();
                      _keyForTextField.currentState!.reset();
                    },
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
                onPressed: () => _setChosenIcon(index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _forwardAllSelected(BuildContext myContext) async {
    var eventholders =
        await myContext.read<EventListCubit>().getEventForwardingHoldersList();
    return await showDialog(
      context: myContext,
      barrierDismissible: true,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Choose page'),
          children: [
            for (var eventHolder in eventholders)
              SimpleDialogOption(
                onPressed: () {
                  myContext
                      .read<EventListCubit>()
                      .forwardAllSelected(eventHolder.eventholderId);
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
