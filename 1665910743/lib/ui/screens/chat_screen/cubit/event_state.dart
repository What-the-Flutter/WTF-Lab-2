part of 'event_cubit.dart';

class EventState {
  final List<Event> eventList;
  final List<String> hasSelected;
  final int selectedIcon;
  final int selectedTag;
  final bool iconAdd;
  final double iconScale;
  final bool animate;
  final String? selectedImage;

  const EventState({
    required this.eventList,
    this.hasSelected = const [],
    this.selectedIcon = -1,
    this.selectedTag = -1,
    this.iconAdd = false,
    this.iconScale = 1.0,
    this.animate = false,
    this.selectedImage,
  });

  EventState copyWith({
    List<Event>? eventList,
    List<String>? hasSelected,
    int? selectedIcon,
    int? selectedTag,
    bool? iconAdd,
    double? iconScale,
    bool? animate,
    String? selectedImage,
  }) {
    return EventState(
      eventList: eventList ?? this.eventList,
      hasSelected: hasSelected ?? this.hasSelected,
      selectedIcon: selectedIcon ?? this.selectedIcon,
      selectedTag: selectedTag ?? this.selectedTag,
      iconAdd: iconAdd ?? this.iconAdd,
      iconScale: iconScale ?? this.iconScale,
      animate: animate ?? false,
      selectedImage: selectedImage,
    );
  }
}
