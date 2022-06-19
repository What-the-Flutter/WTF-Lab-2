import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'eventlist_cubit.dart';
import '../event_list_screen/eventlist_view.dart';

class EventListPage extends StatelessWidget {
  final int _eventHolderId;
  final String _title;

  const EventListPage(
    this._eventHolderId,
    this._title, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EventListCubit(_eventHolderId),
      child: EventListView(_title),
    );
  }
}
