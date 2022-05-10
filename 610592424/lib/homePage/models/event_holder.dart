import '../assets/eventholder_icons_set.dart';
import 'package:flutter/material.dart';

class EventHolder {
  int eventholderId;

  int iconIndex;
  Icon get picture => setOfEventholderIcons[iconIndex];

  String title;

  EventHolder({
    this.eventholderId = -1,
    required this.title,
    required this.iconIndex,
  });

  Map<String, dynamic> toMap() {
    if(eventholderId == -1){
      return {
        'iconIndex': iconIndex,
        'title': title,
      };
    }
    else{
      return {
        'eventholder_id': eventholderId,
        'iconIndex': iconIndex,
        'title': title,
      };
    }
  }

  EventHolder.fromMap(Map<dynamic, dynamic> data)
      : eventholderId = data['eventholder_id'],
        title = data['title'],
        iconIndex = data['iconIndex'];
}
