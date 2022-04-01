import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/category.dart';
import '../models/event.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState());

  final List<Category> _categories = [
    Category('Journal', const Icon(Icons.book, color: Colors.white)),
    Category('Gratitude', const Icon(Icons.grade, color: Colors.white)),
    Category('Notes', const Icon(Icons.menu_book, color: Colors.white)),
  ];

  void init() => emit(state.copyWith(categories: _categories));

  void addCategory(Category category) {
    state.categories.add(category);
    emit(state.copyWith(categories: state.categories));
  }

  void deleteCategory(int index) {
    state.categories.removeAt(index);
    emit(state.copyWith(categories: state.categories));
  }

  void editCategory(int index, Category category) {
    state.categories[index] = category;
    emit(state.copyWith(categories: state.categories));
  }

  void addEvents(List<Event> events, Category category) {
    final categories = List<Category>.from(state.categories);
    final index = categories.indexOf(category);
    for (var event in events) {
      categories[index].events.add(event);
    }
    emit(state.copyWith(categories: categories));
  }
}
