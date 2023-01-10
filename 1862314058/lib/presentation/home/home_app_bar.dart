import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../theme/theme_state.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Home'),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          onPressed: () {
            final cubit = context.read<ThemeCubit>();
            cubit.changeTheme();
          },
          icon: const Icon(
            Icons.water_drop_outlined,
          ),
        ),
      ],
    );
  }
}
