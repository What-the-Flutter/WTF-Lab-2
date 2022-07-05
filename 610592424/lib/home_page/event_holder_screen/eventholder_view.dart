import 'package:diploma/settings_page/settings_view.dart';
import 'package:diploma/statistics_page/summary_stats_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:diploma/models/event_holder.dart';
import 'package:diploma/home_page/event_list_screen/eventList_page.dart';
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
    _cubit = BlocProvider.of<EventHolderCubit>(context);
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
      backgroundColor: Theme.of(context).primaryColor,
      leading: IconButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SummaryStatsPage(),
          ),
        ),
        icon: const Icon(Icons.stacked_bar_chart),
      ),
      title: const Center(
        child: Text("Home"),
      ),
      actions: [
        IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SettingsView(),
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
                  future: _cubit
                      .fetchEventHolderLastEventText(element.eventholderId),
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
                      builder: (context) => EventListPage(
                        element.eventholderId,
                        element.title,
                      ),
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
                    final tempHolder = await _cubit.fetchEventHolder(id);
                    final result = await Navigator.push(
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
                      _cubit.editEventHolder(result as EventHolder);
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
                    _cubit.deleteEventHolder(id);
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
              _cubit.addEventHolder(value as EventHolder)
          },
        );
      },
      child: const Icon(Icons.add, color: Colors.black),
    );
  }
}
