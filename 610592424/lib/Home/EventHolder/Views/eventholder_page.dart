import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:diploma/NewHome/EventHolder/Cubit/eventholder_cubit.dart';
import 'eventholder_view.dart';

class EventHolderPage extends StatelessWidget {
  const EventHolderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EventHolderCubit(),
      child: const EventHolderView(),
    );
  }
}
