import 'package:flutter/material.dart';

abstract class IconRepository {
  void selectIcon(int index);
}

class EmulatorIconRepository implements IconRepository {
  String title = 'Category name';
  List<IconData> icons = [
    Icons.search,
    Icons.home,
    Icons.shopping_cart,
    Icons.delete,
    Icons.description,
    Icons.lightbulb,
    Icons.paid,
    Icons.article,
    Icons.emoji_events,
    Icons.sports_esports,
    Icons.fitness_center,
    Icons.work_outline,
    Icons.spa,
    Icons.celebration,
    Icons.payment,
    Icons.pets,
    Icons.account_balance,
    Icons.savings,
    Icons.family_restroom,
    Icons.crib,
    Icons.music_note,
    Icons.local_bar,
  ];
  int? selectedIcon;

  @override
  void selectIcon(int index) {
    if (selectedIcon != null && selectedIcon != index) {
      selectedIcon = index;
    } else {
      selectedIcon = null;
    }
  }
}
