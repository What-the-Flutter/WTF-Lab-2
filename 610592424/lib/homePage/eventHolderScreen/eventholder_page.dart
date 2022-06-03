import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:diploma/homePage/eventHolderScreen/cubit/eventholder_cubit.dart';
import 'eventholder_view.dart';

class EventHolderPage extends StatelessWidget {
  final User _user;
  const EventHolderPage(this._user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EventHolderCubit(_user),
      child: const EventHolderView(),
    );
  }
}
