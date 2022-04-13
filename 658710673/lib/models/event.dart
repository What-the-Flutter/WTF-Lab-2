class EventFields {
  static final String description = 'description';
  static final String id = 'id';
  static final String timeOfCreation = 'timeOfCreation';
  static final String attachment = 'attachment';
  static final String isBookmarked = 'isBookmarked';
  static final String sectionIcon = 'sectionIcon';
  static final String sectionTitle = 'sectionTitle';
  static final String categoryId = 'categoryId';
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
  int? categoryId;

  Event(
    this.description,
    this.categoryId, {
    this.id,
    this.attachment,
    this.isBookmarked = false,
    this.isSelected = false,
    this.sectionIcon,
    this.sectionTitle = '',
  }) : timeOfCreation = DateTime.now();

  Event.fromDB(
    this.description,
    this.categoryId, {
    required this.id,
    required this.timeOfCreation,
    this.attachment,
    this.isBookmarked = false,
    this.isSelected = false,
    this.sectionIcon,
    this.sectionTitle = '',
  });

  Event copyWith({
    String? description,
    int? categoryId,
    int? id,
    String? attachment,
    bool? isBookmarked,
    bool? isSelected,
    String? sectionTitle,
    int? sectionIcon,
  }) {
    return Event(
      description ?? this.description,
      categoryId ?? this.categoryId,
      id: id ?? this.id,
      attachment: attachment ?? this.attachment,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isSelected: isSelected ?? this.isSelected,
      sectionTitle: sectionTitle ?? this.sectionTitle,
      sectionIcon: sectionIcon ?? this.sectionIcon,
    );
  }

  Event.fromMap(Map<dynamic, dynamic> map)
      : description = map[EventFields.description],
        categoryId = map[EventFields.categoryId],
        timeOfCreation = DateTime.parse(map[EventFields.timeOfCreation]),
        isBookmarked = map[EventFields.isBookmarked] == 0 ? false : true,
        sectionIcon = map[EventFields.sectionIcon],
        sectionTitle = map[EventFields.sectionTitle],
        attachment = map[EventFields.attachment];

  Map<String, dynamic> toMap() {
    return {
      EventFields.description: description,
      EventFields.categoryId: categoryId,
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
