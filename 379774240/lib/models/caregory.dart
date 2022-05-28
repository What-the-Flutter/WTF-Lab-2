import 'package:flutter/material.dart';

import 'event.dart';

class Category {
  final String title;
  final IconData icon;

  late List events;
  late String subtitle;

  Category({
    required this.title,
    required this.icon,
  }) {
    events = <Event>[];
    subtitle = events.isEmpty ? 'No events. Click to create one' : events.last;
  }

  void addEvent(String message, String date) {
    events.add(Event(message: message, date: date));
    subtitle = events.last.message;
  }

  void deleteByIndex(int index) {
    events.removeAt(index);
    subtitle = events.last.message;
  }
}
