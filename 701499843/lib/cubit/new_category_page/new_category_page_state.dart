import '../../models/event_icon.dart';

class NewCategoryPageState {
  final List<EventIcon> iconsList;
  bool writingMode;

  NewCategoryPageState({
    required this.iconsList,
    required this.writingMode,
  });
}
