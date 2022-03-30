import 'package:flutter/material.dart';
import 'event.dart';

class EventCategory {
  final list = <Event>[];
  final Icon icon;
  String title;
  bool pined;

  EventCategory({
    required this.title,
    required this.pined,
    required this.icon,
  });

  Map<String, dynamic> toMap() {
    return {
      'icon': icon.icon!.codePoint,
      'title': title,
      'pined': pined == false ? 0 : 1,
    };
  }
}
