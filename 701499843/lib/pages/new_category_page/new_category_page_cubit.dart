import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/database_provider.dart';
import 'new_category_page_state.dart';

class NewCategoryPageCubit extends Cubit<NewCategoryPageState> {
  NewCategoryPageCubit()
      : super(
          NewCategoryPageState(
            iconsList: [],
            writingMode: false,
          ),
        );

  void init() async {
    emit(
      state.copyWith(
        iconsList: await DatabaseProvider.db.getIcons(),
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
    state.iconsList.addAll(await DatabaseProvider.db.getIcons());

    state.iconsList[index] = state.iconsList[index].copyWith(
      isSelected: true,
      icon: Icon(
        state.iconsList[index].icon.icon,
      ),
    );

    emit(
      NewCategoryPageState(
          iconsList: state.iconsList, writingMode: state.writingMode),
    );
  }
}
