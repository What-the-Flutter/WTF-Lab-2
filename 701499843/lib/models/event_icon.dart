import 'package:flutter/material.dart';

class EventIcon {
  final Icon icon;
  final bool isSelected;

  EventIcon({
    required this.icon,
    this.isSelected = false,
  });

  EventIcon copyWith({
    bool? isSelected,
    Icon? icon,
  }) {
    return EventIcon(
      icon: icon ?? this.icon,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
