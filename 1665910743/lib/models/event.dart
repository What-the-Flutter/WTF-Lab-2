class Event {
  final DateTime date;
  final String image;
  final int iconCode;
  String title;
  bool favorite = false;
  bool isSelected = false;
  String categoryTitle;
  String? id;
  String? imageUrl;
  int tag;

  Event({
    required this.title,
    required this.date,
    required this.favorite,
    required this.categoryTitle,
    required this.iconCode,
    required this.image,
    required this.tag,
  });

  Event.fromMap(Map<dynamic, dynamic> map)
      : title = map['title'] ?? 'title',
        date = DateTime.parse(map['date']),
        favorite = map['favorite'] == 0 ? false : true,
        iconCode = map['icon'],
        categoryTitle = map['categoryTitle'],
        image = map['imagePath'],
        isSelected = map['isSelected'] == 0 ? false : true,
        tag = map['tag'] ?? -1,
        imageUrl = map['imageUrl'];

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'imagePath': image,
      'icon': iconCode,
      'title': title,
      'favorite': favorite ? 1 : 0,
      'isSelected': isSelected ? 1 : 0,
      'date': date.toIso8601String(),
      'categoryTitle': categoryTitle,
      'tag': tag
    };
  }
}
