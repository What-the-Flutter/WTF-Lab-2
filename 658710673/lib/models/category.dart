import 'package:flutter/material.dart';

class CategoryFields {
  static final String id = 'id';
  static final String timeOfCreation = 'timeOfCreation';
  static final String icon = 'icon';
  static final String title = 'title';
}

class Category {
  int? id;
  DateTime timeOfCreation;
  final Icon icon;
  String title;

  Category({
    this.id,
    required this.title,
    required this.icon,
  }) : timeOfCreation = DateTime.now();

  Category.fromDB({
    this.id,
    required this.title,
    required this.icon,
    required this.timeOfCreation,
  });

  Category copyWith({
    int? id,
    String? title,
    Icon? icon,
  }) {
    return Category(
      id: id ?? this.id,
      title: title ?? this.title,
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timeOfCreation': timeOfCreation.toIso8601String(),
      'icon': icon.icon!.codePoint,
      'title': title,
    };
  }

  Category.fromMap(Map<dynamic, dynamic> data)
      : id = data['id'],
        timeOfCreation = data['timeOfCreation'],
        title = data['title'],
        icon = Icon(
          IconData(
            data['icon'],
            fontFamily: 'MaterialIcons',
          ),
        );

  @override
  String toString() {
    return title;
  }
}
