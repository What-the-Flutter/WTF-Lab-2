import 'package:flutter/material.dart';

class SelectMessageAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('1*'),
      leading: const Icon(Icons.close),
      actions: <Widget>[
        const Icon(Icons.flag),
        const Icon(Icons.edit),
        const Icon(Icons.copy),
        const Icon(Icons.bookmark_border),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {},
        ),
      ],
      backgroundColor: Colors.deepPurple,
    );
  }
}
