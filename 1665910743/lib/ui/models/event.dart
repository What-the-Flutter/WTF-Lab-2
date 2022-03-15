import 'dart:io';

class Event {
  String title;
  final DateTime date;
  bool favorite = false;
  File? image;

  Event({
    required this.title,
    required this.date,
    required this.favorite,
    this.image,
  });
}
