import 'package:flutter/material.dart';

class Category {
  final String id;
  final IconData icon;
  String name;
  List<String> events;
  bool pinned;


  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.events,
    required this.pinned, 
  });
}
