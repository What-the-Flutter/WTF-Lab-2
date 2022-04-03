import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/icons_repository.dart';
import 'new_category_page_state.dart';

class NewCategoryPageCubit extends Cubit<NewCategoryPageState> {
  NewCategoryPageCubit(IconsRepository repository)
      : super(
          NewCategoryPageState(
            repository: repository,
            iconsList: [],
            writingMode: false,
          ),
        );

  void init() async {
    emit(
      state.copyWith(
        iconsList: await state.repository.getIcons(),
      ),
    );
  }

  void changeWritingMode(String text) {
    emit(
      state.copyWith(writingMode: text.isNotEmpty),
    );
  }

  void selectIcon(int index) async {
    state.iconsList.clear();
    state.iconsList.addAll(await state.repository.getIcons());

    state.iconsList[index] = state.iconsList[index].copyWith(
      isSelected: true,
      icon: state.iconsList[index].icon,
    );

    emit(
      NewCategoryPageState(
          repository: state.repository,
          iconsList: state.iconsList,
          writingMode: state.writingMode),
    );
  }
}
