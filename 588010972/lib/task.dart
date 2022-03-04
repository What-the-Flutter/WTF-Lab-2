import 'package:flutter/material.dart';
import 'data/event.dart';

class Task {
  String header;
  String lastEvent;
  Icon leadingIcon;
  List<Event> allEvents = [];

  bool isEdited = false;
  bool isPinned = false;

  DateTime dateTimeCreation;

  DateTime? _dataTimeLastUpdate;

  DateTime get dataTimeLastUpdate => _dataTimeLastUpdate != null ?
  _dataTimeLastUpdate! :  DateTime.parse('1960-02-27 13:27:00');

  set dataTimeLastUpdate(DateTime value) {
    if(allEvents.isNotEmpty){
      _dataTimeLastUpdate = allEvents.last.datetime;
    }
    else if(isEdited){
      _dataTimeLastUpdate = value;
    }
  }

  int previousPosition = -1;

  Task.all(this.header, this.lastEvent, this.leadingIcon, this.dateTimeCreation);
}
