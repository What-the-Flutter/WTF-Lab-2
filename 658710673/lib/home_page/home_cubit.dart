import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/firebase_provider.dart';
import '../models/category.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required User? user})
      : _user = user,
        super(HomeState());

  final User? _user;
  late final FirebaseProvider _db = FirebaseProvider(user: _user);

  void init() async {
    emit(state.copyWith(categories: await _db.getAllCategories()));
  }

  void addCategory(Category category) {
    _db.addCategory(category);
    state.categories.add(category);
    emit(state.copyWith(categories: state.categories));
  }

  void deleteCategory(int index) {
    _db.deleteCategory(state.categories[index]);
    state.categories.removeAt(index);
    emit(state.copyWith(categories: state.categories));
  }

  void editCategory(int index, Category category) {
    _db.updateCategory(category);
    state.categories[index] = category;
    emit(state.copyWith(categories: state.categories));
  }
}
