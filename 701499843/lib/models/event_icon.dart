class EventIcon {
  final int id;
  final int icon;
  final bool isSelected;

  EventIcon({
    required this.id,
    required this.icon,
    this.isSelected = false,
  });

  factory EventIcon.fromFirebase(Map<dynamic, dynamic> map) {
    return EventIcon(
      id: map['id'],
      icon: map['icon'],
      isSelected: map['isSelected'],
    );
  }

  EventIcon copyWith({
    int? id,
    bool? isSelected,
    int? icon,
  }) {
    return EventIcon(
      id: id ?? this.id,
      icon: icon ?? this.icon,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'icon': icon,
      'isSelected': isSelected,
    };
  }
}
