import 'package:flutter/material.dart';

class Chat {
  final String category;
  final Icon icon;

  Chat({
    required this.category,
    required this.icon,
  });

  Chat copyWith({
    String? category,
    Icon? icon,
  }) {
    return Chat(
      category: category ?? this.category,
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'icon': icon.icon!.codePoint,
      'category': category,
    };
  }
}
