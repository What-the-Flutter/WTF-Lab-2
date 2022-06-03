import 'package:equatable/equatable.dart';

import '../models/category.dart';
import '../models/event.dart';
import '../models/section.dart';

class CategoryState extends Equatable {
  final List<Event> events;
  final List<Event> searchedEvents;
  final List<Event> filteredEvents;
  final bool isSearchMode;
  final bool isEditingMode;
  final bool isFavoriteMode;
  final Category? category;
  final bool isWritingMode;
  final bool isMessageEdit;
  final bool isAttachment;
  final Category? replyCategory;
  final int replyCategoryIndex;
  final Section? selectedSection;

  CategoryState({
    required this.events,
    required this.searchedEvents,
    required this.filteredEvents,
    this.category,
    this.isFavoriteMode = false,
    this.isSearchMode = false,
    this.isEditingMode = false,
    this.isWritingMode = false,
    this.isMessageEdit = false,
    this.isAttachment = false,
    this.replyCategory,
    this.replyCategoryIndex = 0,
    this.selectedSection,
  });

  CategoryState copyWith({
    List<Event>? events,
    List<Event>? searchedEvents,
    List<Event>? filteredEvents,
    Category? category,
    bool? isSearchMode,
    bool? isWritingMode,
    bool? isEditingMode,
    bool? isMessageEdit,
    bool? isFavoriteMode,
    bool? isAttachment,
    Category? replyCategory,
    int? replyCategoryIndex,
    Section? selectedSection,
  }) {
    return CategoryState(
      events: events ?? this.events,
      searchedEvents: searchedEvents ?? this.searchedEvents,
      filteredEvents: filteredEvents ?? this.filteredEvents,
      category: category ?? this.category,
      isSearchMode: isSearchMode ?? this.isSearchMode,
      isWritingMode: isWritingMode ?? this.isWritingMode,
      isEditingMode: isEditingMode ?? this.isEditingMode,
      isMessageEdit: isMessageEdit ?? this.isMessageEdit,
      isFavoriteMode: isFavoriteMode ?? this.isFavoriteMode,
      isAttachment: isAttachment ?? this.isAttachment,
      replyCategory: replyCategory ?? this.replyCategory,
      replyCategoryIndex: replyCategoryIndex ?? this.replyCategoryIndex,
      selectedSection: selectedSection ?? this.selectedSection,
    );
  }

  @override
  List<Object?> get props => [
        events,
        searchedEvents,
        filteredEvents,
        category,
        isSearchMode,
        isEditingMode,
        isFavoriteMode,
        isWritingMode,
        isMessageEdit,
        isAttachment,
        replyCategory,
        replyCategoryIndex,
        selectedSection,
      ];
}
