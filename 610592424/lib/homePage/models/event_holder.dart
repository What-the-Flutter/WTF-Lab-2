import '../assets/eventholder_icons_set.dart';
import 'package:flutter/material.dart';

class EventHolder {
  int eventholderId;

  int iconIndex;

  Icon get picture => setOfEventholderIcons[iconIndex];

  String title;

  EventHolder({
    required this.title,
    required this.iconIndex,
    this.eventholderId = -1,
  });

  factory EventHolder.withoutId(String title, int iconIndex) {
    return EventHolder(
      title: title,
      iconIndex: iconIndex,
      eventholderId: DateTime.now().millisecondsSinceEpoch,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'eventholder_id': eventholderId,
      'iconIndex': iconIndex,
      'title': title,
    };
  }

  EventHolder.fromMap(Map<dynamic, dynamic> data)
      : eventholderId = data['eventholder_id'],
        title = data['title'],
        iconIndex = data['iconIndex'];
}
