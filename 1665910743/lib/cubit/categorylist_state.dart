import 'package:flutter/material.dart';

import '../models/event.dart';

class EventCategory {
  final list = <Event>[];
  final Icon icon;
  String title;
  bool pined;

  EventCategory(this.title, this.pined, this.icon);
}

class CategoryListState {
  final List<Event> allEvents;
  final bool searchMode;
  final String searchResult;
  final List<EventCategory> categoryList;
  final List<EventCategory> pinedList;

  CategoryListState({
    this.searchResult = '',
    this.searchMode = false,
    required this.categoryList,
    required this.pinedList,
    required this.allEvents,
  });
}
