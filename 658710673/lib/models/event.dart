class EventFields {
  static final String description = 'description';
  static final String id = 'id';
  static final String timeOfCreation = 'timeOfCreation';
  static final String attachment = 'attachment';
  static final String isBookmarked = 'isBookmarked';
  static final String sectionIcon = 'sectionIcon';
  static final String sectionTitle = 'sectionTitle';
  static final String category = 'category';
}

class Event {
  int? id;
  DateTime timeOfCreation;
  String description;
  String? attachment;
  bool isBookmarked;
  bool isSelected = false;
  String sectionTitle;
  int? sectionIcon;
  int? category;

  Event({
    required this.description,
    required this.category,
    this.id,
    this.attachment,
    this.isBookmarked = false,
    this.isSelected = false,
    this.sectionIcon,
    this.sectionTitle = '',
  }) : timeOfCreation = DateTime.now();

  Event.withTime({
    required this.description,
    required this.category,
    this.id,
    this.attachment,
    this.isBookmarked = false,
    this.isSelected = false,
    this.sectionIcon,
    this.sectionTitle = '',
    required this.timeOfCreation,
  });

  factory Event.fromDB(Map<dynamic, dynamic> map) {
    return Event.withTime(
      description: map[EventFields.description],
      category: map[EventFields.category],
      id: map[EventFields.id],
      timeOfCreation: DateTime.parse(map[EventFields.timeOfCreation]),
      attachment: map[EventFields.attachment],
      isBookmarked: map[EventFields.isBookmarked] == 1 ? true : false,
      sectionIcon: map[EventFields.sectionIcon],
      sectionTitle: map[EventFields.sectionTitle],
    );
  }

  Event copyWith({
    String? description,
    int? category,
    int? id,
    String? attachment,
    bool? isBookmarked,
    bool? isSelected,
    String? sectionTitle,
    int? sectionIcon,
  }) {
    return Event(
      description: description ?? this.description,
      category: category ?? this.category,
      id: id ?? this.id,
      attachment: attachment ?? this.attachment,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isSelected: isSelected ?? this.isSelected,
      sectionTitle: sectionTitle ?? this.sectionTitle,
      sectionIcon: sectionIcon ?? this.sectionIcon,
    );
  }

  Event.fromMap(Map<dynamic, dynamic> map)
      : id = map[EventFields.id],
        description = map[EventFields.description],
        category = map[EventFields.category],
        timeOfCreation = DateTime.parse(map[EventFields.timeOfCreation]),
        isBookmarked = map[EventFields.isBookmarked] == 0 ? false : true,
        sectionIcon = map[EventFields.sectionIcon],
        sectionTitle = map[EventFields.sectionTitle],
        attachment = map[EventFields.attachment];

  Map<String, dynamic> toMap() {
    return {
      EventFields.description: description,
      EventFields.category: category,
      EventFields.timeOfCreation: timeOfCreation.toIso8601String(),
      EventFields.isBookmarked: isBookmarked ? 1 : 0,
      EventFields.sectionIcon: sectionIcon,
      EventFields.sectionTitle: sectionTitle,
      EventFields.attachment: attachment,
    };
  }

  @override
  String toString() {
    return description;
  }
}
