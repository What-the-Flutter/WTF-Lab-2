import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ChatCard extends Equatable{

  const ChatCard({
    Key? key,
    required this.icon,
    required this.title,
    this.isSelected = false,
    this.subtitle = 'No Events. Click to create one',
  });

  final Icon icon;
  final String title;
  final String subtitle;
  final bool isSelected;

  ChatCard copyWith({
    Icon? icon,
    String? title,
    String? subtitle,
    bool? isSelected,
  }) {
    return ChatCard(
      icon: icon ?? this.icon,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  String toString() {
    return isSelected.toString();
  }

  @override
  List<Object?> get props => [icon, title, subtitle, isSelected];
}
