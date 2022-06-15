part of 'home_cubit.dart';

@immutable
abstract class HomeState {
  const HomeState();
}

class HomeInitial extends HomeState {
  final String title =
      'Hey! Glad to see you:)\nAre you ready to create your first event category?';

  const HomeInitial();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HomeInitial && other.title == title;
  }

  @override
  int get hashCode => title.hashCode;
}

class HomeLoadingData extends HomeState {
  const HomeLoadingData();
}

class HomeLoadedData extends HomeState {
  final List<model.Category> categories;

  const HomeLoadedData({
    required this.categories,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HomeLoadedData && listEquals(other.categories, categories);
  }

  @override
  int get hashCode => categories.hashCode;
}

class HomeError extends HomeState {
  final String errorMessage;

  const HomeError({
    required this.errorMessage,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HomeError && other.errorMessage == errorMessage;
  }

  @override
  int get hashCode => errorMessage.hashCode;
}
