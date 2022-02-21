
import 'package:flutter/material.dart';

class Group {
  final Icon icon;
  final String title;
  final int? editingIndex;
  Group({
    required this.icon,
    required this.title,
    this.editingIndex,
  });

  Group copyWith({
    Icon? icon,
    String? title,
    int? editingIndex,
  }) {
    return Group(
      icon: icon ?? this.icon,
      title: title ?? this.title,
      editingIndex: editingIndex ?? this.editingIndex,
    );
  }
}
