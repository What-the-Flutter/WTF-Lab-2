import 'package:flutter/material.dart';

import 'event.dart';

class EventCategory {
  final list = <Event>[];
  final Icon icon;
  String title;
  bool pined;

  EventCategory(this.title, this.pined, this.icon);
}

class CategoryList extends ChangeNotifier {
  final List<EventCategory> _categoryList = [];
  final List<EventCategory> _pinedList = [];

  List get categoryList => _categoryList;
  List get pinedList => _pinedList;

  void add(EventCategory category) {
    _categoryList.add(category);
    notifyListeners();
  }

  void remove(EventCategory category) {
    _categoryList.remove(category);
    notifyListeners();
  }

  void pin(EventCategory category) {
    _pinedList.add(category);
    notifyListeners();
  }

  void unpin(EventCategory category) {
    _pinedList.remove(category);
    notifyListeners();
  }
}
