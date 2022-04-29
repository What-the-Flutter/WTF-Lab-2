import 'package:diploma/NewHome/EventHolder/Views/add_eventholder_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:diploma/NewHome/EventHolder/Cubit/eventholder_cubit.dart';
import 'package:diploma/NewHome/EventHolder/Models/event_holder.dart';
import 'package:diploma/NewHome/Additional/theme_widget.dart';
import 'package:diploma/NewHome/Event/Views/eventlist_page.dart';

class EventHolderView extends StatefulWidget {
  const EventHolderView({Key? key}) : super(key: key);

  @override
  State<EventHolderView> createState() => _EventHolderViewState();
}

class _EventHolderViewState extends State<EventHolderView> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: GeneralTheme.of(context).myTheme.themeData,
      child: Scaffold(
        appBar: _appBar(),
        body: _body(context),
        floatingActionButton: _floatingActionButton(context),
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
          onPressed: () => _changeTheme(),
          icon: const Icon(Icons.color_lens),
        ),
      ],
    );
  }

  BlocBuilder _body(BuildContext context) {
    return BlocBuilder<EventHolderCubit, List<EventHolder>>(
        builder: (context, state) {
      return ListView(
        children: <Widget>[
          for (var element in state)
            ListTile(
              leading: element.picture,
              title: Text(element.title),
              subtitle: Text(element.subTitle),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return EventListPage(element.id);
                    },
                  ),
                );
                setState(() {});
              },
              onLongPress: () => _createActionsMenu(element.id, context),
            )
        ],
      );
    });
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
                  onTap: () {
                    EventHolder tempHolder = context
                        .read<EventHolderCubit>()
                        .getEventHolder(id);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return AddEventHolderView(
                            EventHolderViewStates.editing,
                            eventHolder: tempHolder,
                          );
                        },
                      ),
                    ).then(
                      (value) => {
                        if (value != null)
                          context
                              .read<EventHolderCubit>()
                              .editEventHolder(value as EventHolder)
                      },
                    );
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

  FloatingActionButton _floatingActionButton(BuildContext context){
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
