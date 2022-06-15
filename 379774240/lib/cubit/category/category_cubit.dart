import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(const CategoryInitial());

  void selectIcon(int index) {
    var selectedIcon = state.selectedIcon;
    if (selectedIcon != null && selectedIcon != index) {
      selectedIcon = index;
    } else {
      selectedIcon = null;
    }
    emit(state.copyWith(selectedIcon: selectedIcon));
  }
}
