import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/db_provider.dart';
import '../models/category.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState());

  void init() async {
    emit(state.copyWith(categories: await DBProvider.db.getAllCategories()));
  }

  void addCategory(Category category) async {
    final newCat = await DBProvider.db.addCategory(category);
    state.categories.add(newCat);
    emit(state.copyWith(categories: state.categories));
  }

  void deleteCategory(int index) {
    DBProvider.db.deleteCategory(state.categories[index]);
    state.categories.removeAt(index);
    emit(state.copyWith(categories: state.categories));
  }

  void editCategory(int index, Category category) {
    DBProvider.db.updateCategory(category);
    state.categories[index] = category;
    emit(state.copyWith(categories: state.categories));
  }
}
