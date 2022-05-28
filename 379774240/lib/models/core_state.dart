import 'package:flutter/cupertino.dart';

import 'caregory.dart';

@immutable
class CoreState {
  final bool isLightTheme;
  final List categories;

  CoreState({
    this.isLightTheme = true,
    this.categories = const <Category>[],
  });

  void addCategory(String title, IconData icon) {
    categories.add(Category(title: title, icon: icon));
  }

  void removeByIndex(int index) {
    categories.removeAt(index);
  }

  CoreState copyWith({
    bool? isLightTheme,
    List? categories,
  }) =>
      CoreState(
        isLightTheme: isLightTheme ?? this.isLightTheme,
        categories: categories ?? this.categories,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoreState &&
          runtimeType == other.runtimeType &&
          isLightTheme == other.isLightTheme &&
          categories == other.categories;

  @override
  int get hashCode => isLightTheme.hashCode ^ categories.hashCode;
}
