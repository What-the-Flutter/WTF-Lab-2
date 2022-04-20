import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashtagable/hashtagable.dart';

import '../../data/icons.dart';
import '../../models/event.dart';
import '../settings_page/settings_cubit.dart';
import '../settings_page/settings_state.dart';
import 'event_page_cubit.dart';
import 'event_page_state.dart';

class EventPage extends StatefulWidget {
  final String title;
  final List<Event> events;

  const EventPage({
    Key? key,
    required this.title,
    required this.events,
  }) : super(key: key);

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final _controller = TextEditingController();
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  late final EventPageCubit _eventCubit;
  late final SettingsCubit _settingsCubit;

  @override
  void initState() {
    _eventCubit = BlocProvider.of<EventPageCubit>(context);

    super.initState();
    _settingsCubit = BlocProvider.of<SettingsCubit>(context);

    _eventCubit.initValues(widget.title);
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventPageCubit, EventPageState>(
      bloc: _eventCubit,
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: state.editMode
              ? _editAppBar(context, state, _eventCubit)
              : state.searchMode
                  ? _searchAppBar(_eventCubit)
                  : _appBar(state, _eventCubit),
          body: Column(
            children: [
              state.events.isEmpty
                  ? _bodyWithoutEvents()
                  : state.favoriteMode
                      ? _bodyFavorite(
                          state,
                          _eventCubit,
                          _settingsCubit.state,
                        )
                      : _bodyWithEvents(
                          state,
                          _eventCubit,
                          _settingsCubit.state,
                        ),
              Align(
                child: _inputTextField(state, _eventCubit),
                alignment: Alignment.bottomCenter,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _bodyWithoutEvents() {
    return Center(
      child: Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(18.0),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              Text(
                'This is the page where you can track everything about ${widget.title}!\n',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).bottomAppBarColor,
                ),
              ),
              Text(
                'Add your first event to ${widget.title} page by entering some text in the text below and hitting the send button. Long tap the send button to allign the event in the opposite direction. Tap on the bookmark icon on the top right corner to show the bookbark events only.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputTextField(EventPageState state, EventPageCubit cubit) {
    return Column(
      children: [
        Visibility(
          visible: state.isScrollbarVisible,
          child: Scrollbar(
            controller: _scrollController,
            child: Container(
              height: 100,
              child: ListView.builder(
                itemCount: state.chats.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        child: IconButton(
                          icon: icons.elementAt(state.chats[index].icon),
                          onPressed: () => _eventCubit.selectCategory(index),
                          iconSize: 45,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          state.chats[index].category,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  );
                },
                scrollDirection: Axis.horizontal,
              ),
            ),
            isAlwaysShown: false,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: _eventCubit.changeVisibility,
              icon: const Icon(Icons.bubble_chart),
            ),
            Expanded(
              child: TextField(
                onChanged: _eventCubit.changeWritingMode,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  hintText: 'Enter event',
                  filled: true,
                ),
                controller: _controller,
              ),
            ),
            state.writingMode
                ? _sendIconButton(state)
                : IconButton(
                    onPressed: _eventCubit.attachImage,
                    icon: const Icon(
                      Icons.image,
                    ),
                  ),
          ],
        ),
      ],
    );
  }

  Widget _sendIconButton(EventPageState state) {
    return IconButton(
      onPressed: () {
        _eventCubit.addNewEvent(_controller.text, widget.title);
        _controller.text = '';
      },
      icon: const Icon(
        Icons.send,
      ),
    );
  }

  AppBar _appBar(EventPageState state, EventPageCubit cubit) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      title: Text(widget.title),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          onPressed: _eventCubit.changeSearchMode,
          icon: const Icon(Icons.search),
        ),
        IconButton(
          onPressed: _eventCubit.changeFavoriteMode,
          icon: const Icon(Icons.bookmark_border),
        ),
      ],
    );
  }

  AppBar _searchAppBar(EventPageCubit cubit) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        const Padding(
          padding: EdgeInsets.fromLTRB(50, 0, 0, 0),
        ),
        Expanded(
          child: TextField(
            textAlignVertical: TextAlignVertical.bottom,
            decoration: const InputDecoration(
              hintText: 'Enter event',
              filled: true,
            ),
            controller: _searchController,
            onChanged: (text) {
              _eventCubit.setSearchMode(true);
              _eventCubit.search(text);
            },
          ),
        ),
        IconButton(
            onPressed: () {
              _eventCubit.changeSearchMode();
              _searchController.text = '';
            },
            icon: const Icon(Icons.close))
      ],
    );
  }

  AppBar _editAppBar(
      BuildContext context, EventPageState state, EventPageCubit cubit) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      leading: IconButton(
        onPressed: () {
          _eventCubit.changeEditMode();
          _eventCubit.cancelSelection();
        },
        icon: const Icon(Icons.close),
      ),
      title: const Center(
        child: Text('Edit mode'),
      ),
      actions: [
        IconButton(
          onPressed: () {
            _migrateDialog(context, state, _eventCubit);
          },
          icon: Icon(
            Icons.reply,
            color: Theme.of(context).highlightColor,
          ),
        ),
        if (state.events
                .where((element) => element.isSelected == true)
                .length ==
            1)
          IconButton(
            onPressed: () => _eventCubit.copyEventText(_controller),
            icon: const Icon(Icons.edit),
          ),
        IconButton(
          onPressed: () {
            var text = '';
            var it = state.events
                .where((element) => element.isSelected == true)
                .iterator;
            while (it.moveNext()) {
              text += '${it.current.description}' '\n';
            }

            Clipboard.setData(ClipboardData(text: text));
            for (var element in state.events) {
              element = element.copyWith(
                isSelected: false,
              );
            }
          },
          icon: const Icon(Icons.copy),
        ),
        IconButton(
          onPressed: _eventCubit.copy,
          icon: const Icon(Icons.bookmark_outline),
        ),
        IconButton(
          onPressed: () => _dialog(state, context, _eventCubit),
          icon: const Icon(Icons.delete),
        ),
      ],
    );
  }

  Widget _bodyFavorite(
    EventPageState state,
    EventPageCubit cubit,
    SettingsState settingsState,
  ) {
    return Expanded(
      child: ListView.builder(
        itemCount:
            state.events.where((element) => element.isFavorite == true).length,
        itemBuilder: (context, index) => Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: () {
              _eventCubit.setSelectedIndex(index, _searchController);
            },
            onLongPress: () {
              _eventCubit.selectEvent(index);
            },
            child: _eventMessage(
              index,
              state,
              settingsState,
            ),
          ),
        ),
      ),
    );
  }

  Widget _bodyWithEvents(
    EventPageState eventPageState,
    EventPageCubit cubit,
    SettingsState settingsState,
  ) {
    return Expanded(
      child: ListView.builder(
        itemCount: eventPageState.searchMode
            ? eventPageState.searchedEvents.length
            : eventPageState.events.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(eventPageState.events[index].toString()),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(
                      settingsState.centerDate ? 0 : 245, 8, 8, 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(eventPageState.events[index].timeOfCreation),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () =>
                        _eventCubit.tapOnEvent(index, _searchController),
                    onLongPress: () {
                      _eventCubit.selectEvent(index);
                    },
                    onPanUpdate: (details) {
                      if (details.delta.dx > 0) {
                        _eventCubit.setSelectedIndex(index, _controller);
                        _eventCubit.copyEventText(_controller);
                        _eventCubit.removeEvent(index);
                      } else if (details.delta.dx < 0) {
                        {
                          eventPageState.events.removeAt(index);
                          _eventCubit.removeEvent(index);
                        }
                      }
                    },
                    child: _eventMessage(
                      index,
                      eventPageState,
                      settingsState,
                    ),
                  ),
                ),
              ],
            ),
            background: Container(
              color: Theme.of(context).primaryColor,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: const Icon(Icons.edit),
                  ),
                ],
              ),
            ),
            secondaryBackground: Container(
              color: Theme.of(context).primaryColor,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: const Icon(Icons.delete),
                  ),
                ],
              ),
            ),
            onDismissed: (direction) {
              if (direction == DismissDirection.startToEnd) {
                _eventCubit.setSelectedIndex(index, _controller);
                _eventCubit.copyEventText(_controller);
                _eventCubit.removeEvent(index);
              } else if (direction == DismissDirection.endToStart) {
                {
                  eventPageState.events.removeAt(index);
                  _eventCubit.removeEvent(index);
                }
              }
            },
          );
        },
      ),
    );
  }

  Future<void> _migrateDialog(
    BuildContext context,
    EventPageState state,
    EventPageCubit cubit,
  ) {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text(
              'Select the page you want to migrate the selected event(s) to'),
          children: [
            StatefulBuilder(
              builder: ((context, setState) {
                return Container(
                  height: 300,
                  width: 300,
                  child: ListView.builder(
                    itemCount: state.chats.length,
                    itemBuilder: (context, index) {
                      return SimpleDialogOption(
                        child: Text(
                          state.chats[index].category,
                          style: const TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          _eventCubit
                              .setMigrateCategory(state.chats[index].category);
                        },
                      );
                    },
                  ),
                );
              }),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _eventCubit.migrate();
              },
              child: const Text('Ok'),
            )
          ],
        );
      },
    );
  }

  void _dialog(
    EventPageState state,
    BuildContext context,
    EventPageCubit cubit,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Do you want to delete events?'),
        actions: [
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(
                Theme.of(context).primaryColor,
              ),
            ),
            onPressed: () {
              _eventCubit.removeEvents();

              _eventCubit.changeEditMode();
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(
                Theme.of(context).primaryColor,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No'),
          )
        ],
      ),
    );
  }

  Widget _eventMessage(
    int index,
    EventPageState eventPageState,
    SettingsState settingsState,
  ) {
    var image = eventPageState.events[index].image;

    return Container(
      margin:
          EdgeInsets.fromLTRB(settingsState.bubbleAlignment ? 260 : 8, 8, 8, 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: eventPageState.events[index].isSelected
            ? Colors.green[400]
            : Colors.green[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HashTagText(
            text: eventPageState.events[index].description,
            basicStyle: TextStyle(
              color: Theme.of(context).highlightColor,
            ),
            decoratedStyle: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
          if (eventPageState.events[index].isFavorite)
            const Icon(Icons.bookmark_add, size: 12),
          if (image != null)
            Image.file(
              File(image),
            ),
        ],
      ),
    );
  }
}
