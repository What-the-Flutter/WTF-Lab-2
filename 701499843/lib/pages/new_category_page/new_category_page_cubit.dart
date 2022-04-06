import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/icons_repository.dart';
import 'new_category_page_state.dart';

class NewCategoryPageCubit extends Cubit<NewCategoryPageState> {
  final IconsRepository iconsRepository;
  NewCategoryPageCubit(this.iconsRepository)
      : super(
          NewCategoryPageState(
            iconsList: [],
            writingMode: false,
          ),
        );

  void init() async {
    emit(
      state.copyWith(
        iconsList: await iconsRepository.getIcons(),
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
    state.iconsList.addAll(await iconsRepository.getIcons());

    state.iconsList[index] = state.iconsList[index].copyWith(
      isSelected: true,
      icon: state.iconsList[index].icon,
    );

    emit(
      NewCategoryPageState(
          iconsList: state.iconsList, writingMode: state.writingMode),
    );
  }
}
