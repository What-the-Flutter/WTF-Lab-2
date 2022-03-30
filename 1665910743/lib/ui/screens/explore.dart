import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/category_list_cubit.dart';

class Explore extends StatelessWidget {
  static const title = 'Explore';

  const Explore({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Theme.of(context).primaryColor,
        ),
        child: const Text('Delete all data'),
        onPressed: () => context.read<CategoryListCubit>().deleteAll(),
      ),
    );
  }
}
