import 'package:flutter_bloc/flutter_bloc.dart';

import 'create_category_state.dart';

class CreateCategoryPageCubit extends Cubit<CreateCategoryPageState> {
  CreateCategoryPageCubit() : super(CreateCategoryPageState());

  void init() {
    emit(state.copyWith(index: 0));
  }

  void selectIcon(int iconIndex) {
    emit(state.copyWith(index: iconIndex));
  }
}
