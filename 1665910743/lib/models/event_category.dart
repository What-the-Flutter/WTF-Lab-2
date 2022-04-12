import 'package:flutter/material.dart';

class EventCategory {
  final Icon icon;
  String title;
  bool pinned;
  String? id;

  EventCategory({
    required this.title,
    required this.pinned,
    required this.icon,
  });

  Map<String, dynamic> toMap() {
    return {
      'icon': icon.icon!.codePoint,
      'title': title,
      'pinned': pinned == true ? 0 : 1,
    };
  }

  EventCategory.fromMap(Map<dynamic, dynamic> data)
      : title = data['title'],
        pinned = data['pinned'] == 0 ? true : false,
        icon = Icon(
          IconData(
            data['icon'],
            fontFamily: 'MaterialIcons',
          ),
        );
}
