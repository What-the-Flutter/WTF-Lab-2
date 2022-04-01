import '../models/category.dart';
import '../models/section.dart';

class CategoryState {
  bool isSearchMode;
  bool isEditingMode;
  bool isFavoriteMode;
  final Category? category;
  bool isWritingMode;
  bool isMessageEdit;
  bool isAttachment;
  final Category? replyCategory;
  final int replyCategoryIndex;
  final Section? selectedSection;

  CategoryState({
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
}
