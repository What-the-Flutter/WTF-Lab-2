import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Event extends Equatable {
  final int? id;
  final String title;
  final String subtitle;
  final bool isFavorite;
  final bool isComplete;
  final IconData iconData;

  const Event({
    this.id,
    required this.title,
    this.subtitle = 'Tap to add details',
    this.isFavorite = false,
    this.isComplete = false,
    required this.iconData,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        subtitle,
        isFavorite,
        isComplete,
        iconData,
      ];

  Event copyWith({
    int? id,
    String? title,
    String? subtitle,
    bool? isFavorite,
    bool? isComplete,
    IconData? iconData,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      isFavorite: isFavorite ?? this.isFavorite,
      isComplete: isComplete ?? this.isComplete,
      iconData: iconData ?? this.iconData,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'isFavorite': isFavorite ? 1 : 0,
      'isComplete': isComplete ? 1 : 0,
      'iconData': iconData.codePoint,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'] != null ? map['id'] as int : null,
      title: map['title'] as String,
      subtitle: map['subtitle'] as String,
      isFavorite: map['isFavorite'] == 1,
      isComplete: map['isComplete'] == 1,
      iconData: IconData(map['iconData'] as int, fontFamily: 'MaterialIcons'),
    );
  }
}
