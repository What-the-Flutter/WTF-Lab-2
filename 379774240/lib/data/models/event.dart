import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Event extends Equatable {
  final String? id;
  final String title;
  final String lastMessage;
  final IconData iconData;
  final String lastActivity;

  final bool isFavorite;
  final bool isComplete;

  const Event({
    this.id,
    required this.title,
    required this.lastMessage,
    required this.iconData,
    this.lastActivity = 'empty',
    this.isFavorite = false,
    this.isComplete = false,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        lastMessage,
        iconData,
        isFavorite,
        isComplete,
      ];

  Event copyWith({
    String? id,
    String? title,
    String? lastMessage,
    IconData? iconData,
    String? lastActivity,
    bool? isFavorite,
    bool? isComplete,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      lastMessage: lastMessage ?? this.lastMessage,
      iconData: iconData ?? this.iconData,
      lastActivity: lastActivity ?? this.lastActivity,
      isFavorite: isFavorite ?? this.isFavorite,
      isComplete: isComplete ?? this.isComplete,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'lastMessage': lastMessage,
      'iconData': iconData.codePoint,
      'lastActivity': lastActivity,
      'isFavorite': isFavorite,
      'isComplete': isComplete,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'] != null ? map['id'] as String : null,
      title: map['title'] as String,
      lastMessage: map['lastMessage'] as String,
      iconData: IconData(map['iconData'] as int, fontFamily: 'MaterialIcons'),
      lastActivity: map['lastActivity'] as String,
      isFavorite: map['isFavorite'] as bool,
      isComplete: map['isComplete'] as bool,
    );
  }
}
