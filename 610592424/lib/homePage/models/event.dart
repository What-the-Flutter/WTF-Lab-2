import 'package:flutter/material.dart';

import 'package:diploma/homePage/assets/event_icons_set.dart';

class Event{
  final int eventId;

  String text;

  int? iconIndex;
  Icon? get icon => iconIndex == null ? null : setOfEventIcons[iconIndex!];

  bool isSelected = false;

  int eventholderId;

  Event(this.eventId, this.text, this.eventholderId, [this.iconIndex]);

  Map<String, dynamic> toMap() {
    return {
      'event_id': eventId == -1 ? null : eventId,
      'iconIndex': iconIndex,
      'text': text,
      'eventholder_id' : eventholderId,
    };
  }

  Event.fromMap(Map<dynamic, dynamic> data)
      : eventId = data['event_id'],
        text = data['text'],
        iconIndex = data['iconIndex'],
        eventholderId = data['eventholder_id'];
}