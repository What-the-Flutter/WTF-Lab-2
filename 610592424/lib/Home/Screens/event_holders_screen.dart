import '../Entities/event_holder.dart';
import '../Additional/theme_widget.dart';
import 'events_screen.dart';
import 'add_eventholder_screen.dart';
import 'package:diploma/Home/Entities/event.dart';

import 'package:flutter/material.dart';

class EventHoldersScreen extends StatefulWidget {
  const EventHoldersScreen({Key? key}) : super(key: key);

  @override
  State<EventHoldersScreen> createState() => _EventHoldersScreenState();
}

class _EventHoldersScreenState extends State<EventHoldersScreen> {
  final List<EventHolder> _eventHolders = [
    EventHolder(
      id: 0,
      events: [Event(0, "Some text"), Event(1, "Some text 2")],
      title: "Travel",
      pictureIndex: 3,
    ),
    EventHolder(
      id: 1,
      events: [],
      title: "Family",
      pictureIndex: 4,
    ),
    EventHolder(
      id: 2,
      events: [],
      title: "Sports",
      pictureIndex: 5,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: GeneralTheme.of(context).myTheme.themeData,
      child: Scaffold(
        appBar: AppBar(
          //backgroundColor: Colors.green,
          leading: const IconButton(
            onPressed: null,
            icon: Icon(Icons.menu),
          ),
          title: const Center(
            child: Text("Home"),
          ),
          actions: [
            IconButton(
              onPressed: () => _changeTheme(),
              icon: const Icon(Icons.color_lens),
            ),
          ],
        ),
        body: ListView(
          children: <Widget>[
            for (var element in _eventHolders)
              ListTile(
                leading: element.picture,
                title: Text(element.title),
                subtitle: Text(element.subTitle),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return EventsScreen(element);
                      },
                    ),
                  );
                  _rebuildMe();
                },
                onLongPress: () => _createActionsMenu(element.id),
              )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const AddEventHolderScreen(
                    EventHolderScreenStates.adding,
                  );
                },
              ),
            ).then((value) => {
              if(value != null){
                _addEventHolder(value as EventHolder)
              }
            });
          },
          child: const Icon(Icons.add, color: Colors.black),
        ),
      ),
    );
  }

  void _changeTheme() {
    setState(() {
      GeneralTheme.of(context).myTheme.themeData =
          GeneralTheme.of(context).myTheme.isLight
              ? ThemeData.dark()
              : ThemeData.light();

      GeneralTheme.of(context).myTheme.isLight =
          !GeneralTheme.of(context).myTheme.isLight;
    });
  }

  void _rebuildMe() => setState(() {});

  void _createActionsMenu(int id) {
    showModalBottomSheet(
      context: context,
      builder: (builder) => SizedBox(
        height: 270,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Expanded(
                child: ListTile(
                  enabled: false,
                  leading: Icon(Icons.info),
                  title: Text('Info'),
                ),
              ),
              const Expanded(
                child: ListTile(
                  enabled: false,
                  leading: Icon(
                    Icons.pin,
                    color: Colors.green,
                  ),
                  title: Text('Pin/Unpin Page'),
                ),
              ),
              const Expanded(
                child: ListTile(
                  enabled: false,
                  leading: Icon(
                    Icons.archive,
                    color: Colors.yellow,
                  ),
                  title: Text('Archive Page'),
                ),
              ),
              Expanded(
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return AddEventHolderScreen(
                            EventHolderScreenStates.editing,
                            eventHolder: _eventHolders
                                .firstWhere((element) => element.id == id),
                          );
                        },
                      ),
                    ).then((value) => {
                      if(value != null){
                        _editEventHolder(value as EventHolder)
                      }
                    });
                  },
                  leading: const Icon(
                    Icons.edit,
                    color: Colors.blue,
                  ),
                  title: const Text('Edit Page'),
                ),
              ),
              Expanded(
                child: ListTile(
                  onTap: () => _deleteEventHolder(id),
                  leading: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  title: const Text('Delete Page'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteEventHolder(int id) {
    setState(() {
      _eventHolders.removeWhere((element) => element.id == id);
    });
  }

  void _addEventHolder(EventHolder tempEventHolder) {
    setState(() {
      _eventHolders.add(
        EventHolder(
          id: _eventHolders.isNotEmpty ? _eventHolders.last.id + 1 : 0,
          events: [],
          title: tempEventHolder.title,
          pictureIndex: tempEventHolder.pictureIndex,
        ),
      );
    });
  }

  void _editEventHolder(EventHolder newEventHolder) {
    setState(() {
      var oldEventHolder = _eventHolders
          .firstWhere((element) => element.id == newEventHolder.id);

      oldEventHolder.pictureIndex = newEventHolder.pictureIndex;
      oldEventHolder.title = newEventHolder.title;
    });
  }
}
