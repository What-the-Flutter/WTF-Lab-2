import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ChatCard extends Equatable {
  final int? id;
  final Icon icon;
  final String title;
  final String subtitle;
  final bool isSelected;

  const ChatCard({
    this.id,
    required this.icon,
    required this.title,
    this.isSelected = false,
    this.subtitle = 'No Events. Click to create one',
  });

  ChatCard copyWith({
    int? id,
    Icon? icon,
    String? title,
    String? subtitle,
    bool? isSelected,
  }) {
    return ChatCard(
      id: id ?? this.id,
      icon: icon ?? this.icon,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  factory ChatCard.fromJson(Map<String, dynamic> json) {
    return ChatCard(
      id: json['chat_id'],
      icon: Icon(IconData(json['icon'], fontFamily: 'MaterialIcons')),
      title: json['title'],
      subtitle: json['subtitle'],
      isSelected: json['is_selected'] == 0 ? false : true,
    );
  }

  Map<String,dynamic> toJson(){
    return {
      'chat_id': id,
      'icon': icon.icon?.codePoint.toString(),
      'title': title,
      'subtitle': subtitle,
      'is_selected': isSelected == false ? 0 : 1,
    };
  }


  @override
  String toString() {
    return '$title ${icon.icon!.codePoint.toString()}';
  }

  @override
  List<Object?> get props => [id, icon, title, subtitle, isSelected];
}
