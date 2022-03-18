import 'dart:io';

class Event {
  final DateTime date;
  String title;
  bool favorite = false;
  File? image;
  bool isSelected = false;

  Event({
    required this.title,
    required this.date,
    required this.favorite,
    this.image,
  });
}

