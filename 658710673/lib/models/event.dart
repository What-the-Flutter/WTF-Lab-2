import 'dart:io';

import 'section.dart';

class Event {
  Event(
    this.description, {
    this.attachment,
    this.isBookmarked = false,
    this.isSelected = false,
    this.section,
  });

  DateTime timeOfCreation = DateTime.now();
  String description;
  File? attachment;
  bool isBookmarked;
  bool isSelected;
  Section? section;

  @override
  String toString() {
    return description;
  }
}
