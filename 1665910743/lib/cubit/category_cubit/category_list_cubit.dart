import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/event.dart';
import '../../models/event_category.dart';
import '../../repository/database_repository.dart';
import 'category_list_state.dart';

class CategoryListCubit extends Cubit<CategoryListState> {
  final DataBaseRepository dataBaseRepository;
  CategoryListCubit({required this.dataBaseRepository})
      : super(
          CategoryListState(),
        );

  void add(EventCategory category) {
    dataBaseRepository.addCategory(category);

    emit(
      CategoryListState(),
    );
  }

  void remove(EventCategory category, String key) {
    dataBaseRepository.removeCategory(key);
    emit(
      CategoryListState(),
    );
  }

  void pin(EventCategory category, String key) async {
    dataBaseRepository.pinCategory(key);
    emit(
      CategoryListState(),
    );
  }

  void unpin(EventCategory category, String key) {
    dataBaseRepository.unpinCategory(key);

    emit(
      CategoryListState(),
    );
  }

  void moveEvent(String key, String newCategory) {
    dataBaseRepository.moveEvent(
      key,
      newCategory,
    );
  }

  void getImage(String name) async {
    final url = await dataBaseRepository.getImageUrl(name);

    emit(
      CategoryListState(imageUrl: url),
    );
  }

  void enterSearchMode() {
    emit(
      CategoryListState(
        searchMode: true,
      ),
    );
  }

  void searchControll(String value) {
    emit(
      CategoryListState(
        searchMode: state.searchMode,
        searchResult: value,
      ),
    );
  }

  void exitSearch() {
    emit(
      CategoryListState(
        searchMode: false,
      ),
    );
  }

  void addEvent({required String categoryTitle, required Event event}) {
    dataBaseRepository.addEvent(event);
    emit(
      CategoryListState(),
    );
  }

  void removeEventInCategory({required String key}) {
    dataBaseRepository.removeEvent(key);
    emit(
      CategoryListState(),
    );
  }

  void eventRename({
    required String key,
    required String newTitle,
  }) async {
    dataBaseRepository.renameEvent(key, newTitle);

    emit(
      CategoryListState(),
    );
  }

  void bookMarkEvent({
    required String key,
    required bool isBook,
  }) {
    dataBaseRepository.bookmarkEvent(key, isBook);

    emit(
      CategoryListState(),
    );
  }

  void deleteAll() {
    dataBaseRepository.deleteDB();

    emit(
      CategoryListState(),
    );
  }

  void categoryRename({
    required String key,
    required String newTitle,
  }) async {
    dataBaseRepository.renameCategory(key, newTitle);

    emit(
      CategoryListState(),
    );
  }

  void eventSelect(String key) {
    dataBaseRepository.eventSelected(key);

    emit(
      CategoryListState(),
    );
  }

  void eventNotSelect(String key) {
    dataBaseRepository.eventNotSelected(key);

    emit(
      CategoryListState(),
    );
  }

  void getAuthKey() async {
    final key = await dataBaseRepository.getAuthKey();

    emit(
      CategoryListState(authKey: key ?? false),
    );
  }

  void setAuthKey(bool key) {
    dataBaseRepository.setAuthKey(key);

    emit(
      CategoryListState(authKey: key),
    );
  }
}
