import 'package:flutter/material.dart';
import '../models/event.dart';

class PageInfo {
  late String title;
  String subtitle = 'No Events. Click to create one.';
  late Icon icon;
  late DateTime createdTime;
  late DateTime lastEditTime;
  List<Event> eventList = [];
  bool isPinned = false;

  PageInfo(this.title, this.icon, this.createdTime, this.lastEditTime);
}
