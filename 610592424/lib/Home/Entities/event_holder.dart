import 'event.dart';
import '../Additional/eventholder_icons_set.dart';
import 'package:flutter/material.dart';

class EventHolder {
  final int id;
  final List<Event> events;
  String title;
  int pictureIndex;
  Icon get picture {
    return setOfEventholderIcons[pictureIndex];
  }

  String get subTitle {
    return events.isNotEmpty ? events.last.text : "No events";
  }

  EventHolder({this.id = 0, required this.events, required this.title, required this.pictureIndex,});
}