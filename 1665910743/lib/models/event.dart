import 'dart:io';

import 'package:flutter/material.dart';

class Event {
  final DateTime date;
  String title;
  bool favorite = false;
  File? image;
  Icon? icon;
  bool isSelected = false;
  int categoryIndex;

  Event({
    required this.title,
    required this.date,
    required this.favorite,
    required this.categoryIndex,
    this.image,
    this.icon,
  });
}
