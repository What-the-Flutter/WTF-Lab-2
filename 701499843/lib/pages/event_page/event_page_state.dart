import '../../models/chat.dart';
import '../../models/event.dart';

class EventPageState {
  final List<Event> events;
  final bool editMode;
  final bool favoriteMode;
  final bool writingMode;
  final bool searchMode;
  final String? image;
  final int selectedIndex;
  final List<Chat> chats;
  final List<Event> searchedEvents;
  final String migrateCategory;
  final bool isScrollbarVisible;
  final String selectedCategory;
  final String title;

  EventPageState({
    required this.events,
    this.image,
    required this.writingMode,
    required this.editMode,
    required this.favoriteMode,
    required this.selectedIndex,
    required this.searchMode,
    required this.chats,
    required this.searchedEvents,
    required this.migrateCategory,
    required this.isScrollbarVisible,
    required this.selectedCategory,
    required this.title,
  });

  EventPageState copyWith({
    List<Event>? events,
    bool? editMode,
    bool? favoriteMode,
    bool? writingMode,
    bool? searchMode,
    String? image,
    int? selectedIndex,
    List<Chat>? chats,
    List<Event>? searchedEvents,
    String? migrateCategory,
    bool? isScrollbarVisible,
    String? selectedCategory,
    String? title,
  }) {
    return EventPageState(
      events: events ?? this.events,
      editMode: editMode ?? this.editMode,
      favoriteMode: favoriteMode ?? this.favoriteMode,
      writingMode: writingMode ?? this.writingMode,
      searchMode: searchMode ?? this.searchMode,
      image: image ?? this.image,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      chats: chats ?? this.chats,
      searchedEvents: searchedEvents ?? this.searchedEvents,
      migrateCategory: migrateCategory ?? this.migrateCategory,
      isScrollbarVisible: isScrollbarVisible ?? this.isScrollbarVisible,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      title: title ?? this.title,
    );
  }
}
