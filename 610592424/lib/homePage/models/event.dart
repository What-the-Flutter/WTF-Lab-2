import 'package:flutter/material.dart';

import 'package:diploma/homePage/assets/event_icons_set.dart';

class Event {
  final int eventId;
  String text;
  bool isSelected = false;
  int eventholderId;
  String? imagePath;

  int? iconIndex;

  Icon? get icon => iconIndex == null ? null : setOfEventIcons[iconIndex!];

  Event(this.eventId, this.text, this.eventholderId,
      [this.iconIndex, this.imagePath]);

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

  Map<String, dynamic> toMap() {
    return {
      'event_id': eventId,
      'iconIndex': iconIndex,
      'text': text,
      'eventholder_id': eventholderId,
      'image_path': imagePath,
    };
  }

  Event.fromMap(Map<dynamic, dynamic> data)
      : eventId = data['event_id'],
        text = data['text'],
        iconIndex = data['iconIndex'],
        eventholderId = data['eventholder_id'],
        imagePath = data['image_path'];
}
