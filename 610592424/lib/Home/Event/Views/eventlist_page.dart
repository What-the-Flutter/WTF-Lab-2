import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:diploma/NewHome/Event/Cubit/eventslist_cubit.dart';
import 'eventlist_view.dart';

class EventListPage extends StatelessWidget {
  final int _eventHolderId;
  const EventListPage(this._eventHolderId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EventListCubit(_eventHolderId),
      child: const EventListView(),
    );
  }
}
