import '../eventholder_icons_set.dart';
import 'package:flutter/material.dart';

class EventHolder {
  final String title;
  final int eventholderId;
  final int iconIndex;
  Icon get picture => setOfEventholderIcons[iconIndex];

  EventHolder({
    required this.title,
    required this.iconIndex,
    this.eventholderId = -1,
  });

  EventHolder copyWith({int? iconIndex, String? title}) {
    return EventHolder(
      title: title ?? this.title,
      iconIndex: iconIndex ?? this.iconIndex,
      eventholderId: eventholderId,
    );
  }

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
