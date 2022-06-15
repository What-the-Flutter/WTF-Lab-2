import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import '../../data/categories_repository.dart';
import '../../data/models/category.dart' as model;

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final CategoriesRepository _categoriesRepository;

  HomeCubit(this._categoriesRepository) : super(const HomeInitial());

  Future<void> fetchCategories() async {
    try {
      emit(const HomeLoadingData());
      final categories = await _categoriesRepository.fetchCategories();
      if (categories.isEmpty) {
        emit(const HomeInitial());
      } else {
        emit(HomeLoadedData(categories: categories));
      }
    } on Exception {
      emit(const HomeError(
          errorMessage: "Coludn't fetch data:(\nIs the device online?"));
    }
  }

  Future<void> removeCategory(int index) async {
    _categoriesRepository.removeCategory(index);

    try {
      emit(const HomeLoadingData());
      final categories = await _categoriesRepository.fetchCategories();
      if (categories.isEmpty) {
        emit(const HomeInitial());
      } else {
        emit(HomeLoadedData(categories: categories));
      }
    } on Exception {
      emit(const HomeError(
          errorMessage: "Coludn't fetch data:(\nIs the device online?"));
    }
  }

  Future<void> likeCategory(int index) async {
    _categoriesRepository.likeCategory(index);

    try {
      emit(const HomeLoadingData());
      final categories = await _categoriesRepository.fetchCategories();
      if (categories.isEmpty) {
        emit(const HomeInitial());
      } else {
        emit(HomeLoadedData(categories: categories));
      }
    } on Exception {
      emit(const HomeError(
          errorMessage: "Coludn't fetch data:(\nIs the device online?"));
    }
  }

  Future<void> addCategory(model.Category category) async {
    _categoriesRepository.addCategory(category);

    try {
      emit(const HomeLoadingData());
      final categories = await _categoriesRepository.fetchCategories();
      if (categories.isEmpty) {
        emit(const HomeInitial());
      } else {
        emit(HomeLoadedData(categories: categories));
      }
    } on Exception {
      emit(const HomeError(
          errorMessage: "Coludn't fetch data:(\nIs the device online?"));
    }
  }

  Future<void> editCategory(int index, model.Category category) async {
    _categoriesRepository.addCategory(category);

    try {
      emit(const HomeLoadingData());
      final categories = await _categoriesRepository.fetchCategories();
      if (categories.isEmpty) {
        emit(const HomeInitial());
      } else {
        emit(HomeLoadedData(categories: categories));
      }
    } on Exception {
      emit(const HomeError(
          errorMessage: "Coludn't fetch data:(\nIs the device online?"));
    }
  }
}
