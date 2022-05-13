import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/category.dart';
import '../screens/home/add_event_screen.dart';

class ListItem extends StatelessWidget {
  final Category category;

  const ListItem({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddEvent(category: category)),
        );
      },
      title: Text(
        category.name,
        style: const TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
      subtitle: Text(
        category.emptymessge,
        style: const TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
      ),
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.supportingColor,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: Icon(
            category.iconData,
            color: AppColors.primaryColor,
            size: 30,
          ),
        ),
      ),
    );
  }
}
