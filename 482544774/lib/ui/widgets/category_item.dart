import 'package:flutter/material.dart';

import '../../data/category_list.dart';
import '../screens/event.dart';

class CategoryItem extends StatelessWidget {
  final int index;
  final Function optionsHandler;
  late final currentElement = categoryList[index];

  CategoryItem(this.index, this.optionsHandler, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey,
        radius: 20,
        child: Icon(currentElement.icon, color: Colors.white),
      ),
      title: Text(
        currentElement.name,
        style: const TextStyle(
          fontSize: 22,
        ),
      ),
      subtitle: Text(
        (currentElement.events.isEmpty)
            ? 'No events'
            : currentElement.events.first,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
      ),
      trailing: currentElement.pinned
          ? const Icon(Icons.push_pin)
          : const Icon(Icons.arrow_forward),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => EventScreen(
              title: currentElement.name,
              events: currentElement.events,
            ),
          ),
        );
      },
      onLongPress: () => optionsHandler(index),
    );
  }
}
