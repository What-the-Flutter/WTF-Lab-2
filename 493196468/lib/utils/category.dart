import 'package:flutter/material.dart';

class Category {
  final int? id;
  final Icon icon;
  final String title;
  final bool isSelected;

  const Category({
    this.id,
    required this.icon,
    required this.title,
    this.isSelected = false,
  });

  Category copyWith({
    int? id,
    Icon? icon,
    String? title,
    bool? isSelected,
  }) {
    return Category(
      id: id ?? this.id,
      icon: icon ?? this.icon,
      title: title ?? this.title,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['category_id'],
      icon: Icon(IconData(json['icon'], fontFamily: 'MaterialIcons')),
      title: json['title'],
      isSelected: json['is_selected'] == 0 ? false : true,
    );
  }

  Map<String,dynamic> toJson(){
    return {
      'chat_id': id,
      'icon': icon.icon?.codePoint.toString(),
      'title': title,
      'is_selected': isSelected == false ? 0 : 1,
    };
  }


  @override
  String toString() {
    return '$title ${icon.icon!.codePoint.toString()}';
  }
}
