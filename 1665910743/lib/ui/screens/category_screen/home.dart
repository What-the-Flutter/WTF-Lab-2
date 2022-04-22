import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../chat_screen/cubit/event_cubit.dart';
import 'cubit/category_cubit.dart';
import 'unpined_list.dart';

class HomeScreen extends StatelessWidget {
  static const title = 'Home';

  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnpinedCategory(
      categoryCubit: context.read<CategoryCubit>(),
      eventCubit: context.read<EventCubit>(),
    );
  }
}
