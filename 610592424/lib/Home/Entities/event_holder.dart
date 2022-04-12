import 'event.dart';
import 'package:flutter/material.dart';

class EventHolder{
  final List<Event> events;

  String title;
  String subTitle;

  Icon picture;

  EventHolder(this.events, this.title, this.picture, [this.subTitle = "No events"]);
}