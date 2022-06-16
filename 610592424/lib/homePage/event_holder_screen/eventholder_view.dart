import 'package:diploma/animation_page/animation_rive_view.dart';
import 'package:diploma/homePage/settings_screen/settings_cubit.dart';
import 'package:diploma/homePage/settings_screen/settings_view.dart';
import 'package:diploma/timeline_page/timeline_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:diploma/homePage/models/event_holder.dart';
import 'package:diploma/homePage/event_list_screen/eventList_page.dart';
import 'add_eventholder_view.dart';
import 'eventholder_cubit.dart';
import 'eventholder_state.dart';

class EventHolderView extends StatefulWidget {
  const EventHolderView({Key? key}) : super(key: key);

  @override
  State<EventHolderView> createState() => _EventHolderViewState();
}

class _EventHolderViewState extends State<EventHolderView> {
  late final EventHolderCubit _cubit;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<SettingsCubit>(context).loadTheme();
    _cubit = BlocProvider.of<EventHolderCubit>(context);
    _cubit.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(context),
      floatingActionButton: _floatingActionButton(context),
      bottomNavigationBar: _bottomNavBar(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      leading: const IconButton(
        onPressed: null,
        icon: Icon(Icons.menu),
      ),
      title: const Center(
        child: Text("Home"),
      ),
      actions: [
        IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const SettingsView();
              },
            ),
          ),
          icon: const Icon(Icons.settings),
        ),
      ],
    );
  }

  BlocBuilder _body(BuildContext context) {
    return BlocBuilder<EventHolderCubit, EventHolderState>(
      builder: (context, state) {
        return ListView(
          children: <Widget>[
            for (var element in state.eventHolders)
              ListTile(
                leading: element.picture,
                title: Text(element.title),
                subtitle: FutureBuilder(
                  future:
                      _cubit.getEventHolderLastEventText(element.eventholderId),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data!);
                    } else {
                      return const Text('no events');
                    }
                  },
                ),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return EventListPage(
                          element.eventholderId,
                          element.title,
                        );
                      },
                    ),
                  );
                  setState(() {});
                },
                onLongPress: () =>
                    _createActionsMenu(element.eventholderId, context),
              )
          ],
        );
      },
    );
  }

  void _createActionsMenu(int id, BuildContext context) {
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
                  onTap: () async {
                    EventHolder tempHolder = await context
                        .read<EventHolderCubit>()
                        .getEventHolder(id);
                    var result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return AddEventHolderView(
                            EventHolderViewStates.editing,
                            eventHolder: tempHolder,
                          );
                        },
                      ),
                    );
                    if (result != null) {
                      context
                          .read<EventHolderCubit>()
                          .editEventHolder(result as EventHolder);
                      Navigator.pop(context);
                    }
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
                  onTap: () {
                    context.read<EventHolderCubit>().deleteEventHolder(id);
                    Navigator.pop(context);
                  },
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

  FloatingActionButton _floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const AddEventHolderView(
                EventHolderViewStates.adding,
              );
            },
          ),
        ).then(
          (value) => {
            if (value != null)
              context
                  .read<EventHolderCubit>()
                  .addEventHolder(value as EventHolder)
          },
        );
      },
      child: const Icon(Icons.add, color: Colors.black),
    );
  }

  BottomNavigationBar _bottomNavBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.business),
          label: 'Timeline',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.handyman),
          label: 'Animation',
        ),
      ],
      currentIndex: 0,
      selectedItemColor: Colors.amber[800],
      onTap: (index) {
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const TimelinePage();
              },
            ),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const MyRiveAnimation();
              },
            ),
          );
        }
      },
    );
  }
}
