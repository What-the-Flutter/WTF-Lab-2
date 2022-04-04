import 'package:flutter/material.dart';
import 'event.dart';

class EventCategory {
  final list = <Event>[];
  final Icon icon;
  String title;
  bool pinned;

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

  factory EventCategory.fromRTDB(Map<String, dynamic> data) {
    return EventCategory(
      title: data['title'],
      pinned: data['pinned'] == 0 ? false : true,
      icon: Icon(
        IconData(data['icon']),
      ),
    );
  }
}
