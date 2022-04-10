import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Category_Screen/cubit/category_cubit.dart';

class Explore extends StatefulWidget {
  static const title = 'Explore';

  const Explore({Key? key}) : super(key: key);

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  @override
  void didChangeDependencies() {
    context.read<CategoryCubit>().getCat();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return const Center();
  }
}
