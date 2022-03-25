import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/categorylist_cubit.dart';
import '../../cubit/categorylist_state.dart';
import '../widgets/unpined_list.dart';

class HomeScreen extends StatefulWidget {
  static const title = 'Home';

  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategorylistCubit, CategoryListState>(
      bloc: CategorylistCubit(),
      builder: (context, state) {
        return const UnpinedCategory();
      },
    );
  }
}
