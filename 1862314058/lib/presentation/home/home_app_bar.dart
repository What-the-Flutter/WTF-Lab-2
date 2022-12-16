import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Home'),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.water_drop_outlined,
          ),
        ),
      ],
    );
  }
}
