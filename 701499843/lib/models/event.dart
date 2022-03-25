class Event {
  late final DateTime timeOfCreation = DateTime.now();
  final String description;
  final String? image;
  final bool isFavorite;
  final bool isSelected;
  final String category;

  Event({
    this.description = '',
    this.image,
    this.isFavorite = false,
    this.isSelected = false,
    this.category = '',
  });

  Event copyWith({
    String? description,
    String? image,
    bool? isSelected,
    bool? isFavorite,
    String? category,
  }) {
    return Event(
      description: description ?? this.description,
      image: image ?? this.image,
      isFavorite: isFavorite ?? this.isFavorite,
      isSelected: isSelected ?? this.isSelected,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'isSelected': isSelected,
      'image': image,
      'isFavorite': isFavorite,
      'category': category,
      'timeOfCreation': timeOfCreation.toString(),
    };
  }

  @override
  String toString() {
    return '$timeOfCreation: $description';
  }
}
