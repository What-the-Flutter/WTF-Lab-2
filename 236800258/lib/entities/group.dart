import 'package:flutter/material.dart';

class Group implements Comparable {
  final int? editingIndex;
  final DateTime createdAt;
  Icon groupIcon;
  String title;
  bool isPinned = false;
  DateTime editedAt;

  Group({
    required this.groupIcon,
    required this.title,
    required this.createdAt,
    required this.editedAt,
    this.editingIndex,
  });

  Group copyWith({
    int? editingIndex,
    Icon? groupIcon,
    String? title,
    bool? isPinned,
    DateTime? createdAt,
    DateTime? editedAt,
  }) {
    return Group(
      editingIndex: editingIndex ?? this.editingIndex,
      groupIcon: groupIcon ?? this.groupIcon,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      editedAt: editedAt ?? this.editedAt,
    );
  }

  @override
  int compareTo(dynamic other) {
    if (isPinned == false && other.isPinned == true) {
      return 1;
    }
    if (isPinned == true && other.isPinned == false) {
      return -1;
    }
    return 0;
  }
}
