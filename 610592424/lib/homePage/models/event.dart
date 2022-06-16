import 'package:flutter/material.dart';

import 'package:diploma/homePage/constant_icons/event_icons_set.dart';

class Event {
  final int eventId;
  String text;
  bool isSelected = false;
  int eventholderId;
  String? imagePath;
  int? iconIndex;
  Icon? get icon => iconIndex == null ? null : setOfEventIcons[iconIndex!];
  DateTime? timeOfCreation;

  Event(
    this.eventId,
    this.text,
    this.eventholderId, [
    this.iconIndex,
    this.imagePath,
    this.timeOfCreation,
  ]);

  factory Event.withoutId({
    required String text,
    required int eventholderId,
    int? iconIndex,
    String? imagePath,
  }) {
    return Event(
      DateTime.now().millisecondsSinceEpoch,
      text,
      eventholderId,
      iconIndex,
      imagePath,
    );
  }

  Map<String, dynamic> toMap({bool leavePrevDate = false}) {
    return {
      'event_id': eventId,
      'iconIndex': iconIndex,
      'text': text,
      'eventholder_id': eventholderId,
      'image_path': imagePath,
      'time_of_creation' : leavePrevDate ? timeOfCreation!.toIso8601String() : DateTime.now().toIso8601String(),
    };
  }

  Event.fromMap(Map<dynamic, dynamic> data)
      : eventId = data['event_id'],
        text = data['text'],
        iconIndex = data['iconIndex'],
        eventholderId = data['eventholder_id'],
        imagePath = data['image_path'],
        timeOfCreation = DateTime.parse(data['time_of_creation']);
}
