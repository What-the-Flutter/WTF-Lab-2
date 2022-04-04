import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/database_provider.dart';
import '../../models/event.dart';
import '../../models/event_category.dart';
import '../../repository/database_repository.dart';
import 'category_list_state.dart';

class CategoryListCubit extends Cubit<CategoryListState> {
  final DataBaseRepository dataBaseRepository;
  CategoryListCubit({required this.dataBaseRepository})
      : super(
          CategoryListState(
            categoryList: [],
            allEvents: [],
          ),
        );

  void fetchEventsInCategory(int categoryIndex) async {
    final eventsFromDb = await DataBase.db.getEventList(
      state.categoryList[categoryIndex].title,
    );
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
    dataBaseRepository.addCategory(category);

    state.categoryList.add(category);

    emit(
      CategoryListState(
        categoryList: state.categoryList,
        allEvents: state.allEvents,
      ),
    );
  }

  void remove(EventCategory category, String key) {
    state.categoryList.removeWhere(
      (element) => element.title == category.title,
    );
    dataBaseRepository.removeCategory(key);
    emit(
      CategoryListState(
        categoryList: state.categoryList,
        allEvents: state.allEvents,
      ),
    );
  }

  void pin(EventCategory category, String key) async {
    for (final element in state.categoryList) {
      if (element.title == category.title) {
        element.pinned = true;
      }
    }
    dataBaseRepository.pinCategory(key);
    emit(
      CategoryListState(
        categoryList: await DataBase.db.getCategoryList(),
        allEvents: state.allEvents,
      ),
    );
  }

  void unpin(EventCategory category, String key) {
    for (final element in state.categoryList) {
      if (element.title == category.title) {
        element.pinned = true;
      }
    }
    dataBaseRepository.unpinCategory(key);

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
    dataBaseRepository.moveEvent(
      state.categoryList[oldCategory].list[listIndex].title,
      state.categoryList[newCategory].title,
    );
    state.categoryList[newCategory].list.add(
      state.categoryList[oldCategory].list[listIndex],
    );
    state.categoryList[newCategory].list[listIndex].categoryTitle =
        state.categoryList[newCategory].title;
    state.categoryList[oldCategory].list.removeAt(listIndex);
  }

  void enterSearchMode() {
    emit(
      CategoryListState(
        allEvents: state.allEvents,
        categoryList: state.categoryList,
        searchMode: true,
      ),
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

  void addEvent({required String categoryTitle, required Event event}) {
    for (var element in state.categoryList) {
      if (element.title == categoryTitle) {
        element.list.add(event);
      }
    }
    dataBaseRepository.addEvent(event);
    emit(
      CategoryListState(
        allEvents: state.allEvents,
        categoryList: state.categoryList,
      ),
    );
  }

  void removeEventInCategory({required String key}) {
    dataBaseRepository.removeEvent(key);
    emit(
      CategoryListState(
        allEvents: state.allEvents,
        categoryList: state.categoryList,
      ),
    );
  }

  void eventRename({
    required String key,
    required String newTitle,
  }) async {
    dataBaseRepository.renameEvent(key, newTitle);

    emit(
      CategoryListState(
        allEvents: state.allEvents,
        categoryList: state.categoryList,
      ),
    );
  }

  void bookMarkEvent({
    required String key,
    required bool isBook,
  }) {
    dataBaseRepository.bookmarkEvent(key, isBook);

    emit(
      CategoryListState(
        allEvents: state.allEvents,
        categoryList: state.categoryList,
      ),
    );
  }

  void deleteAll() {
    dataBaseRepository.deleteDB();

    emit(
      CategoryListState(
        categoryList: [],
        allEvents: [],
      ),
    );
  }

  void categoryRename({
    required String key,
    required String newTitle,
  }) async {
    dataBaseRepository.renameCategory(key, newTitle);

    emit(
      CategoryListState(
        allEvents: state.allEvents,
        categoryList: state.categoryList,
      ),
    );
  }

  void eventSelect(String key) {
    dataBaseRepository.eventSelected(key);

    emit(
      CategoryListState(
        allEvents: state.allEvents,
        categoryList: state.categoryList,
      ),
    );
  }

  void eventNotSelect(String key) {
    dataBaseRepository.eventNotSelected(key);

    emit(
      CategoryListState(
        allEvents: state.allEvents,
        categoryList: state.categoryList,
      ),
    );
  }

  void getAuthKey() async {
    final key = await dataBaseRepository.getAuthKey();
    
    emit(
      CategoryListState(
          allEvents: state.allEvents,
          categoryList: state.categoryList,
          authKey: key ?? false),
    );
  }

  void setAuthKey(bool key) {
    dataBaseRepository.setAuthKey(key);

    emit(
      CategoryListState(
        allEvents: state.allEvents,
        categoryList: state.categoryList,
      ),
    );
  }
}
