part of 'category_cubit.dart';
class CategoryState {
  final List<Category> categories;
  final bool isUnderChoice;

  CategoryState({required this.categories, required this.isUnderChoice});

  CategoryState copyWith({
    List<Category>? categories,
    bool? isUnderChoice,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      isUnderChoice: isUnderChoice ?? this.isUnderChoice,
    );
  }
}