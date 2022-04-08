class Chat {
  final int id;
  final String category;
  final int icon;

  Chat({
    required this.id,
    required this.category,
    required this.icon,
  });

  factory Chat.fromFirebase(Map<dynamic, dynamic> map) {
    return Chat(
      id: map['id'],
      category: map['category'],
      icon: map['icon'],
    );
  }

  Chat copyWith({
    int? id,
    String? category,
    int? icon,
  }) {
    return Chat(
      id: id ?? this.id,
      category: category ?? this.category,
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'icon': icon,
      'category': category,
    };
  }
}
