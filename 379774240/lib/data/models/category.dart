import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'event.dart';

@immutable
class Category {
  final String title;
  final String subtitle;
  final IconData iconData;
  final List<Event> events;
  final bool isFavorive;

  Category({
    required this.title,
    required this.iconData,
    this.events = const [],
    this.subtitle = 'No events. Click to create one',
    this.isFavorive = false,
  });

  Category copyWith({
    String? title,
    String? subtitle,
    IconData? iconData,
    List<Event>? events,
    bool? isFavorive,
  }) {
    return Category(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      iconData: iconData ?? this.iconData,
      events: events ?? this.events,
      isFavorive: isFavorive ?? this.isFavorive,
    );
  }

  @override
  String toString() {
    return 'Category(title: $title, subtitle: $subtitle, iconData: $iconData, events: $events, isFavorive: $isFavorive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Category &&
        other.title == title &&
        other.subtitle == subtitle &&
        other.iconData == iconData &&
        listEquals(other.events, events) &&
        other.isFavorive == isFavorive;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        subtitle.hashCode ^
        iconData.hashCode ^
        events.hashCode ^
        isFavorive.hashCode;
  }
}
