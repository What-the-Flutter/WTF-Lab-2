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

  Category({this.id, required this.title, required this.icon, required this.timeOfCreation});

  factory Category.fromDB(Map<dynamic, dynamic> json) {
    return Category(
        id: json[CategoryFields.id],
        title: json[CategoryFields.title],
        icon: json[CategoryFields.icon],
        timeOfCreation: json[CategoryFields.timeOfCreation]);
  }

  factory Category.withoutId(String title, Icon icon) {
    final now = DateTime.now();
    return Category(id: now.millisecondsSinceEpoch, title: title, icon: icon, timeOfCreation: now);
  }

  Category copyWith({
    int? id,
    String? title,
    Icon? icon,
    DateTime? timeOfCreation,
  }) {
    return Category(
        id: id ?? this.id,
        title: title ?? this.title,
        icon: icon ?? this.icon,
        timeOfCreation: timeOfCreation ?? this.timeOfCreation);
  }

  Map<String, dynamic> toMap() {
    return {
      CategoryFields.id: id,
      CategoryFields.timeOfCreation: timeOfCreation.toIso8601String(),
      CategoryFields.icon: icon.icon!.codePoint,
      CategoryFields.title: title,
    };
  }

  Category.fromMap(Map<dynamic, dynamic> data)
      : id = data[CategoryFields.id],
        timeOfCreation = DateTime.parse(data[CategoryFields.timeOfCreation]),
        title = data[CategoryFields.title],
        icon = Icon(
          IconData(
            data[CategoryFields.icon],
            fontFamily: 'MaterialIcons',
          ),
        );

  @override
  String toString() {
    return title;
  }
}
