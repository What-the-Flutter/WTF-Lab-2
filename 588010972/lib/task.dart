import 'package:flutter/material.dart';
import 'data/event.dart';

class Task {
  String header;
  String lastEvent;
  Icon leadingIcon;
  List<Event> allEvents = [];

  Task.all(this.header, this.lastEvent, this.leadingIcon);
}
