import 'package:diploma/NewHome/Event/Models/event.dart';
import '../Assets/eventholder_icons_set.dart';
import 'package:flutter/material.dart';

class EventHolder {
  int id;
  final List<Event> events;

  int pictureIndex;
  Icon get picture => setOfEventholderIcons[pictureIndex];

  String title;
  String get subTitle => events.isNotEmpty ? events.last.text : "No events";

  EventHolder({
    this.id = 0,
    required this.events,
    required this.title,
    required this.pictureIndex,
  });
}
