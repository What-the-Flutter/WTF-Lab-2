import 'package:flutter/material.dart';

import '../constants.dart';

class ListItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const ListItem(
    this.title,
    this.subtitle,
    this.icon, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
      subtitle: Text(
        subtitle,
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
            icon,
            color: AppColors.primaryColor,
            size: 30,
          ),
        ),
      ),
    );
  }
}
