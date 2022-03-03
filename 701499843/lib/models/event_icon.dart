import 'package:flutter/material.dart';

class EventIcon {
  final Icon icon;
  final bool isSelected;

  EventIcon({
    required this.icon,
    this.isSelected = false,
  });

  EventIcon copyWith({
    required bool isSelected,
    required Icon icon,
  }) {
    return EventIcon(
      icon: icon,
      isSelected: isSelected,
    );
  }
}
