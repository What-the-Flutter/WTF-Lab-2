class Event {
  final DateTime date;
  final String? image;
  final int iconCode;
  String title;
  bool favorite = false;
  bool isSelected = false;
  String categoryTitle;

  Event({
    required this.title,
    required this.date,
    required this.favorite,
    required this.categoryTitle,
    required this.iconCode,
    this.image,
  });

  Event.fromMap(Map<dynamic, dynamic> map)
      : title = map['title'],
        date = DateTime.parse(map['date']),
        favorite = map['favorite'] == 0 ? false : true,
        iconCode = map['icon'],
        categoryTitle = map['categoryTitle'],
        image = map['imagePath'];

  Map<String, dynamic> toMap() {
    return {
      'imagePath': image ?? '',
      'icon': iconCode,
      'title': title,
      'favorite': favorite ? 1 : 0,
      'isSelected': isSelected ? 1 : 0,
      'date': date.toIso8601String(),
      'categoryTitle': categoryTitle,
    };
  }
}
