import '../models/category.dart';

class HomeState {
  final List<Category> categories;
  final int? index;
  final int currTabIndex;

  HomeState({
    this.categories = const [],
    this.index = 0,
    this.currTabIndex = 0,
  });

  HomeState copyWith({
    List<Category>? categories,
    int? index,
    int? currTabIndex,
  }) {
    return HomeState(
      categories: categories ?? this.categories,
      index: index ?? this.index,
      currTabIndex: currTabIndex ?? this.currTabIndex,
    );
  }
}
