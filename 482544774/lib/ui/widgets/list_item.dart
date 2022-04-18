import 'package:flutter/material.dart';

import '../../data/category_list.dart';
import '../screens/event.dart';

class ListItem extends StatelessWidget {
  const ListItem(this.index, {Key? key}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    final currentElement = categoryList[index];

    return ListTile(
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => EventScreen())),
      leading: CircleAvatar(
        backgroundColor: Colors.grey,
        radius: 20,
        child: currentElement.icon,
      ),
      title: Text(
        currentElement.name,
        style: const TextStyle(
          fontSize: 22,
        ),
      ),
      subtitle: Text(
        currentElement.status,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward,
      ),
    );
  }
}
