class Event {
  final DateTime timeOfCreation = DateTime.now();
  final String description;
  final String? image;
  final bool isFavorite;
  final bool isSelected;

  Event(
      {this.description = '',
      this.image,
      this.isFavorite = false,
      this.isSelected = false});

  Event copyWith({
    required String description,
    String? image,
    required bool isSelected,
    required bool isFavorite,
  }) {
    return Event(
      description: description,
      image: image ?? this.image,
      isFavorite: isFavorite,
      isSelected: isSelected,
    );
  }

  @override
  String toString() {
    return '$timeOfCreation: $description';
  }
}
