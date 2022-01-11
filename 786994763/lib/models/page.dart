import 'package:flutter/material.dart';
import '../models/event.dart';

class PageInfo {
  late String title;
  String subtitle = 'No Events. Click to create one.';
  late Icon icon;
  late DateTime createdTime;
  late DateTime lastEditTime;
  List<Event> eventList = [];
  List<Event> favEventsList = [];
  bool isPinned = false;
  bool isSelected = false;

  PageInfo(this.title, this.icon, this.createdTime, this.lastEditTime);
}
