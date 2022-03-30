import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/database_provider.dart';
import '../models/event_category.dart';
import 'category_list_state.dart';

class CategoryListCubit extends Cubit<CategoryListState> {
  CategoryListCubit()
      : super(
          CategoryListState(
            categoryList: [],
            allEvents: [],
          ),
        );

  void init() async {
    final _categoryList = await DataBase.db.getCategoryList();
    for (var element in _categoryList) {
      element.list.addAll(
        await DataBase.db.getEventList(element.title),
      );
    }
    emit(
      CategoryListState(
        categoryList: _categoryList,
        allEvents: state.allEvents,
      ),
    );
  }

  void fetchEventsInCategory(int categoryIndex) async {
    final eventsFromDb =
        await DataBase.db.getEventList(state.categoryList[categoryIndex].title);
    if (state.categoryList[categoryIndex].list.isEmpty) {
      state.categoryList[categoryIndex].list.addAll(eventsFromDb);
    }
    emit(
      CategoryListState(
        categoryList: state.categoryList,
        allEvents: state.allEvents,
      ),
    );
  }

  void add(EventCategory category) {
    state.categoryList.add(category);
    DataBase.db.addCategory(category);

    emit(
      CategoryListState(
        categoryList: state.categoryList,
        allEvents: state.allEvents,
      ),
    );
  }

  void remove(EventCategory category) {
    state.categoryList
        .removeWhere((element) => element.title == category.title);
    DataBase.db.removeCategory(category.title);
    emit(
      CategoryListState(
        categoryList: state.categoryList,
        allEvents: state.allEvents,
      ),
    );
  }

  void removeAt(int index) {
    state.categoryList.removeAt(index);
    emit(
      CategoryListState(
        categoryList: state.categoryList,
        allEvents: state.allEvents,
      ),
    );
  }

  void pin(EventCategory category, int index) async {
    state.categoryList.elementAt(index).pined = true;
    DataBase.db.pinCategory(category.title);
    emit(
      CategoryListState(
        categoryList: await DataBase.db.getCategoryList(),
        allEvents: state.allEvents,
      ),
    );
  }

  void unpin(EventCategory category, int index) {
    state.categoryList.elementAt(index).pined = false;
    DataBase.db.unpinCategory(category.title);

    emit(
      CategoryListState(
        categoryList: state.categoryList,
        allEvents: state.allEvents,
      ),
    );
  }

  void fetchAllEvents() {
    state.allEvents.clear();
    for (var i = 0; i < state.categoryList.length; i++) {
      state.allEvents.addAll(
        state.categoryList[i].list,
      );
    }

    emit(
      CategoryListState(
        categoryList: state.categoryList,
        allEvents: state.allEvents,
      ),
    );
  }

  void moveEvent(int oldCategory, int newCategory, int listIndex) {
    DataBase.db.moveEvent(
      state.categoryList[oldCategory].list[listIndex].title,
      state.categoryList[newCategory].title,
    );
    state.categoryList[newCategory].list.add(
      state.categoryList[oldCategory].list[listIndex],
    );
    state.categoryList[newCategory].list[listIndex].categoryIndex = newCategory;
    state.categoryList[newCategory].list[listIndex].categoryTitle =
        state.categoryList[newCategory].title;
    state.categoryList[oldCategory].list.removeAt(listIndex);
  }

  void enterSearchMode() {
    emit(
      CategoryListState(
          allEvents: state.allEvents,
          categoryList: state.categoryList,
          searchMode: true),
    );
  }

  void searchControll(String value) {
    emit(
      CategoryListState(
        allEvents: state.allEvents,
        categoryList: state.categoryList,
        searchMode: state.searchMode,
        searchResult: value,
      ),
    );
  }

  void exitSearch() {
    emit(
      CategoryListState(
        allEvents: state.allEvents,
        categoryList: state.categoryList,
        searchMode: false,
      ),
    );
  }

  void removeEventInCategory({
    required int categoryIndex,
    required int eventIndex,
    required String title,
  }) {
    state.categoryList[categoryIndex].list.removeAt(eventIndex);
    DataBase.db.removeEvent(title);
    emit(
      CategoryListState(
        allEvents: state.allEvents,
        categoryList: state.categoryList,
      ),
    );
  }

  void eventRename({
    required String title,
    required int categoryIndex,
    required int eventIndex,
    required String newTitle,
  }) {
    DataBase.db.renameEvent(title, newTitle);
    state.categoryList[categoryIndex].list.elementAt(eventIndex).title =
        newTitle;

    emit(
      CategoryListState(
        allEvents: state.allEvents,
        categoryList: state.categoryList,
      ),
    );
  }

  void bookMarkEvent({
    required String title,
    required int categoryIndex,
    required int eventIndex,
  }) {
    state.categoryList[categoryIndex].list[eventIndex].favorite
        ? DataBase.db.bookmarkEvent(title, true)
        : DataBase.db.bookmarkEvent(title, false);
    state.categoryList[categoryIndex].list[eventIndex].favorite =
        !state.categoryList[categoryIndex].list[eventIndex].favorite;

    emit(
      CategoryListState(
        allEvents: state.allEvents,
        categoryList: state.categoryList,
      ),
    );
  }

  void deleteAll() {
    DataBase.db.delete();

    emit(
      CategoryListState(
        categoryList: [],
        allEvents: [],
      ),
    );
  }

  void categoryRename({
    required int categoryIndex,
    required String newTitle,
  }) async {
    DataBase.db
        .renameCategory(state.categoryList[categoryIndex].title, newTitle);
    state.categoryList[categoryIndex].title = newTitle;

    emit(
      CategoryListState(
        allEvents: state.allEvents,
        categoryList: state.categoryList,
      ),
    );
  }
}
