import 'package:bloc/bloc.dart';

import '../../../../models/event_category.dart';
import '../../../../repository/database_repository.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  DataBaseRepository dataBaseRepository;

  CategoryCubit({required this.dataBaseRepository})
      : super( CategoryState(categoryList: []));

  void add(EventCategory category) async {
    dataBaseRepository.addCategory(category);
    state.categoryList.clear();
    state.categoryList.addAll(
      await dataBaseRepository.getCategorys(),
    );

    emit(
      CategoryState(categoryList: state.categoryList),
    );
  }

  void remove(EventCategory category, String key) async {
    dataBaseRepository.removeCategory(key);
    state.categoryList.clear();
    state.categoryList.addAll(
      await dataBaseRepository.getCategorys(),
    );

    emit(CategoryState(
      categoryList: await dataBaseRepository.getCategorys(),
    ));
  }

  void pin(EventCategory category, String key) async {
    dataBaseRepository.pinCategory(key);
    state.categoryList.clear();
    state.categoryList.addAll(
      await dataBaseRepository.getCategorys(),
    );

    emit(
      CategoryState(categoryList: state.categoryList),
    );
  }

  void unpin(EventCategory category, String key) async {
    dataBaseRepository.unpinCategory(key);
    state.categoryList.clear();
    state.categoryList.addAll(
      await dataBaseRepository.getCategorys(),
    );

    emit(
      CategoryState(categoryList: state.categoryList),
    );
  }

  void getCat() async {
    state.categoryList.addAll(
      await dataBaseRepository.getCategorys(),
    );

    emit(
      CategoryState(categoryList: state.categoryList),
    );
  }

  void categoryRename({
    required String key,
    required String newTitle,
    required String oldTitle,
  }) async {
    dataBaseRepository.renameCategory(
      key,
      newTitle,
      oldTitle,
    );
    state.categoryList.clear();
    state.categoryList.addAll(
      await dataBaseRepository.getCategorys(),
    );

    emit(
      CategoryState(categoryList: state.categoryList),
    );
  }
}
