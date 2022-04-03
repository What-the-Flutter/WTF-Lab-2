import '../../data/repositories/icons_repository.dart';
import '../../models/event_icon.dart';

class NewCategoryPageState {
  final IconsRepository repository;

  final List<EventIcon> iconsList;
  final bool writingMode;

  NewCategoryPageState({
    required this.repository,
    required this.iconsList,
    required this.writingMode,
  });

  NewCategoryPageState copyWith({
    List<EventIcon>? iconsList,
    bool? writingMode,
  }) {
    return NewCategoryPageState(
      repository: repository,
      iconsList: iconsList ?? this.iconsList,
      writingMode: writingMode ?? this.writingMode,
    );
  }
}
