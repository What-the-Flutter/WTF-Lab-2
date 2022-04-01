import '../models/category.dart';

class HomeState {
  final List<Category> categories;
  int? index;

  HomeState({
    this.categories = const [],
    this.index = 0,
  });

  HomeState copyWith({
    List<Category>? categories,
    int? index,
  }) {
    return HomeState(
      categories: categories ?? this.categories,
      index: index ?? this.index,
    );
  }
}