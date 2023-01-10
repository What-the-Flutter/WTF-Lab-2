import 'package:bloc/bloc.dart';

import '../../../../utils/category.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {

  CategoryCubit() : super(CategoryState(categories: [], isUnderChoice: false));

  void showCategories() {
    emit(
      state.copyWith(
        isUnderChoice: state.isUnderChoice ? false : true,
      ),
    );
  }

  void closeCategories() => emit(state.copyWith(isUnderChoice: false));
}
