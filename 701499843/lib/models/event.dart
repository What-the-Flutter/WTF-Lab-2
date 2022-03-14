class Event {
  final DateTime timeOfCreation = DateTime.now();
  final String description;
  final String? image;
  final bool isFavorite;
  final bool isSelected;

  Event({
    this.description = '',
    this.image,
    this.isFavorite = false,
    this.isSelected = false,
  });

  Event copyWith({
    String? description,
    String? image,
    bool? isSelected,
    bool? isFavorite,
  }) {
    return Event(
      description: description ?? this.description,
      image: image ?? this.image,
      isFavorite: isFavorite ?? this.isFavorite,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  String toString() {
    return '$timeOfCreation: $description';
  }
}
