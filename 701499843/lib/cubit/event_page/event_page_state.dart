import 'package:flutter/material.dart';

import '../../models/event.dart';

class EventPageState {
  final List<Event> events;
  bool editMode;
  bool favoriteMode;
  bool writingMode;
  bool searchMode;
  String? image;
  int selectedIndex;
  Map<String, Icon> chats;
  List<Event> searchedEvents;
  String migrateCategory;
  bool isScrollbarVisible;
  String selectedCategory;
  String title;

  EventPageState({
    required this.events,
    this.image,
    required this.writingMode,
    required this.editMode,
    required this.favoriteMode,
    required this.selectedIndex,
    required this.searchMode,
    required this.chats,
    required this.searchedEvents,
    required this.migrateCategory,
    required this.isScrollbarVisible,
    required this.selectedCategory,
    required this.title,
  });
}
