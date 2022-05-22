import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './cubit/eventlist_cubit.dart';
import 'eventList_view.dart';

class EventListPage extends StatelessWidget {
  final int _eventHolderId;
  final String _title;
  final User _user;

  const EventListPage(
    this._eventHolderId,
    this._title,
    this._user, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EventListCubit(_eventHolderId, _user),
      child: EventListView(_title),
    );
  }
}
