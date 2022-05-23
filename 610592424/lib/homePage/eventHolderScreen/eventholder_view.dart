import 'package:diploma/homePage/settings_screen/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:diploma/homePage/models/event_holder.dart';
import 'package:diploma/homePage/eventListScreen/eventList_page.dart';
import 'add_eventholder_view.dart';
import './cubit/eventholder_cubit.dart';
import './cubit/eventholder_state.dart';

class EventHolderView extends StatefulWidget {
  const EventHolderView({Key? key}) : super(key: key);

  @override
  State<EventHolderView> createState() => _EventHolderViewState();
}

class _EventHolderViewState extends State<EventHolderView> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<EventHolderCubit>(context).init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(context),
      floatingActionButton: _floatingActionButton(context),
    );
  }

  AppBar _appBar() {
    return AppBar(
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
                  future: BlocProvider.of<EventHolderCubit>(context)
                      .getEventHolderLastEventText(element.eventholderId),
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
                  var user = BlocProvider.of<EventHolderCubit>(context).getUser;
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return EventListPage(
                          element.eventholderId,
                          element.title,
                          user,
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
                  onTap: () =>
                      context.read<EventHolderCubit>().deleteEventHolder(id),
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
}
