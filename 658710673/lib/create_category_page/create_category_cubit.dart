import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/category.dart';
import '../utils/constants.dart';
import 'create_category_state.dart';

class CreateCategoryPageCubit extends Cubit<CreateCategoryPageState> {
  CreateCategoryPageCubit() : super(CreateCategoryPageState());

  void init() {
    emit(state.copyWith(index: 0));
  }

  Category? createCategory(String title) {
    if (title.isEmpty) {
      return null;
    }
    return Category(title, Icon(CategoryIcons.icons[state.selectedIcon].icon, color: Colors.white));
  }

  void editCategory(Category category) {
    emit(state.copyWith());
  }

  void selectIcon(int iconIndex) {
    emit(state.copyWith(index: iconIndex));
  }
}
