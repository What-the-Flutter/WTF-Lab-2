import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../icons.dart';
import 'new_category_page_state.dart';

class NewCategoryPageCubit extends Cubit<NewCategoryPageState> {
  NewCategoryPageCubit()
      : super(
          NewCategoryPageState(iconsList: icons(), writingMode: false),
        );

  void changeWritingMode(String text) {
    state.writingMode = text.isNotEmpty;

    emit(
      NewCategoryPageState(
          iconsList: state.iconsList, writingMode: state.writingMode),
    );
  }

  void selectIcon(int index, BuildContext context) {
    state.iconsList.clear();
    state.iconsList.addAll(icons());

    state.iconsList[index] = state.iconsList[index].copyWith(
      isSelected: true,
      icon: Icon(
        state.iconsList[index].icon.icon,
        color: Theme.of(context).hintColor,
      ),
    );

    emit(
      NewCategoryPageState(
          iconsList: state.iconsList, writingMode: state.writingMode),
    );
  }
}
