import 'package:flutter/material.dart';

class Event{
  final int id;

  String text;

  Icon? icon;

  bool isSelected = false;

  Event(this.id, this.text, [this.icon]);
}