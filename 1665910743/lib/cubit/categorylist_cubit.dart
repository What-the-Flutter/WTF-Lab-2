import 'package:flutter_bloc/flutter_bloc.dart';

import 'categorylist_state.dart';

class CategorylistCubit extends Cubit<CategoryListState> {
  CategorylistCubit()
      : super(
            CategoryListState(categoryList: [], pinedList: [], allEvents: []));

  void add(EventCategory category) {
    state.categoryList.add(category);

    emit(
      CategoryListState(
        categoryList: state.categoryList,
        pinedList: state.pinedList,
        allEvents: state.allEvents,
      ),
    );
  }

  void remove(EventCategory category) {
    state.categoryList.removeWhere(
        (element) => element.title.hashCode == category.title.hashCode);
    emit(
      CategoryListState(
        categoryList: state.categoryList,
        pinedList: state.pinedList,
        allEvents: state.allEvents,
      ),
    );
  }

  void removeAt(int index) {
    state.categoryList.removeAt(index);
    emit(
      CategoryListState(
        categoryList: state.categoryList,
        pinedList: state.pinedList,
        allEvents: state.allEvents,
      ),
    );
  }

  void pin(EventCategory category) {
    state.pinedList.add(category);
    state.categoryList.removeWhere(
        (element) => element.title.hashCode == category.title.hashCode);
    emit(
      CategoryListState(
        categoryList: state.categoryList,
        pinedList: state.pinedList,
        allEvents: state.allEvents,
      ),
    );
  }

  void unPin(EventCategory category) {
    state.categoryList.add(category);
    state.pinedList.removeWhere(
        (element) => element.title.hashCode == category.title.hashCode);
    state.categoryList.where((element) => element.title == category.title);
    emit(
      CategoryListState(
        categoryList: state.categoryList,
        pinedList: state.pinedList,
        allEvents: state.allEvents,
      ),
    );
  }

  void fetchAllEvents() {
    state.allEvents.clear();
    for (var i = 0; i < state.categoryList.length; i++) {
      state.allEvents.addAll(state.categoryList[i].list);
    }

    for (var i = 0; i < state.pinedList.length; i++) {
      state.allEvents.addAll(state.pinedList[i].list);
    }

    emit(
      CategoryListState(
          categoryList: state.categoryList,
          pinedList: state.pinedList,
          allEvents: state.allEvents),
    );
  }

  void moveEvent(int oldCategory, int newCategory, int listIndex) {
    state.categoryList[newCategory].list.add(
      state.categoryList[oldCategory].list[listIndex],
    );
    state.categoryList[newCategory].list[listIndex].categoryIndex = newCategory;
    state.categoryList[oldCategory].list.removeAt(listIndex);
  }

  void enterSearchMode() {
    emit(
      CategoryListState(
          allEvents: state.allEvents,
          categoryList: state.categoryList,
          pinedList: state.pinedList,
          searchMode: true),
    );
  }

  void searchControll(String value) {
    emit(
      CategoryListState(
          allEvents: state.allEvents,
          categoryList: state.categoryList,
          pinedList: state.pinedList,
          searchMode: state.searchMode,
          searchResult: value),
    );
  }

  void exitSearch() {
    emit(
      CategoryListState(
          allEvents: state.allEvents,
          categoryList: state.categoryList,
          pinedList: state.pinedList,
          searchMode: false),
    );
  }

  void removeEventInCategory({
    required int categoryIndex,
    required int eventIndex,
  }) {
    state.categoryList[categoryIndex].list.removeAt(eventIndex);

    emit(
      CategoryListState(
        allEvents: state.allEvents,
        categoryList: state.categoryList,
        pinedList: state.pinedList,
      ),
    );
  }

  void eventRename({
    required int categoryIndex,
    required int eventIndex,
    required String newTitle,
  }) {
    state.categoryList[categoryIndex].list.elementAt(eventIndex).title =
        newTitle;

    emit(
      CategoryListState(
        allEvents: state.allEvents,
        categoryList: state.categoryList,
        pinedList: state.pinedList,
      ),
    );
  }

  void categoryRename({
    required int categoryIndex,
    required String newTitle,
  }) {
    state.categoryList[categoryIndex].title = newTitle;

    emit(
      CategoryListState(
        allEvents: state.allEvents,
        categoryList: state.categoryList,
        pinedList: state.pinedList,
      ),
    );
  }

  @override
  void onChange(Change<CategoryListState> change) {
    super.onChange(change);
  }
}
