import 'package:bloc/bloc.dart';

class FilterCubit extends Cubit<List<String>> {
  FilterCubit() : super([]);

  void addCategoryFromFilter(String categoryName) {
    if (state.contains(categoryName)) {
      print(state);
      emit(state);
    } else {
      state.add(categoryName);
      print(state);
      emit(state);
    }
  }

  void reset() {
    state.clear();
    emit(state);
  }
}
