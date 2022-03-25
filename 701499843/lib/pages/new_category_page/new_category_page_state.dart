import '../../models/event_icon.dart';

class NewCategoryPageState {
  final List<EventIcon> iconsList;
  final bool writingMode;

  NewCategoryPageState({
    required this.iconsList,
    required this.writingMode,
  });

  NewCategoryPageState copyWith({
    List<EventIcon>? iconsList,
    bool? writingMode,
  }) {
    return NewCategoryPageState(
      iconsList: iconsList ?? this.iconsList,
      writingMode: writingMode ?? this.writingMode,
    );
  }
}
