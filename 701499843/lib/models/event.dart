class Event {
  final int id;
  final String timeOfCreation;
  final String description;
  final String? image;
  final bool isFavorite;
  final bool isSelected;
  final String category;

  Event({
    required this.id,
    required this.timeOfCreation,
    this.description = '',
    this.image,
    this.isFavorite = false,
    this.isSelected = false,
    this.category = '',
  });

  Event copyWith({
    int? id,
    String? description,
    String? image,
    bool? isSelected,
    bool? isFavorite,
    String? category,
    String? timeOfCreation,
  }) {
    return Event(
      id: id ?? this.id,
      description: description ?? this.description,
      image: image ?? this.image,
      isFavorite: isFavorite ?? this.isFavorite,
      isSelected: isSelected ?? this.isSelected,
      category: category ?? this.category,
      timeOfCreation: timeOfCreation ?? this.timeOfCreation,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'isSelected': isSelected,
      'image': image,
      'isFavorite': isFavorite,
      'category': category,
      'timeOfCreation': timeOfCreation,
    };
  }

  factory Event.fromFirebase(Map<dynamic, dynamic> map) {
    return Event(
      id: map['id'],
      timeOfCreation: map['timeOfCreation'],
      description: map['description'],
      isSelected: map['isSelected'],
      image: map['image'],
      isFavorite: map['isFavorite'],
      category: map['category'],
    );
  }

  @override
  String toString() {
    return '$timeOfCreation: $description';
  }
}
