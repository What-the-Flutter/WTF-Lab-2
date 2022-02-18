class Event {
  String content;
  final bool isRight;
  final DateTime eventDate;
  bool isSelected = false;
  bool isFavorite = false;

  Event({
    required this.content,
    required this.eventDate,
    required this.isRight,
  });
}
