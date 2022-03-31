import 'dart:io';

class Event {
  final DateTime date;
  final File? image;
  final int iconCode;
  String title;
  bool favorite = false;
  bool isSelected = false;
  int categoryIndex;
  String categoryTitle;

  Event({
    required this.title,
    required this.date,
    required this.favorite,
    required this.categoryIndex,
    required this.categoryTitle,
    required this.iconCode,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'imagePath' : image?.path ?? '',
      'icon': iconCode,
      'title': title,
      'favorite': favorite ? 1 : 0,
      'date': date.toIso8601String(),
      'categoryIndex': categoryIndex,
      'categoryTitle': categoryTitle,
    };
  }
}
