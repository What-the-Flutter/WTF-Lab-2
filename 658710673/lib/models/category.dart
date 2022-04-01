import 'package:flutter/material.dart';

import 'event.dart';

class Category{
  DateTime timeOfCreation = DateTime.now();
  List<Event> events = [];
  List<Event> searchedEvents = [];
  String title;
  Icon icon;

  Category(this.title, this.icon);

  @override
  String toString() {
    return title;
  }
}