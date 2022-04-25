import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../repository/database_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  DataBaseRepository dataBaseRepository;

  HomeCubit({required this.dataBaseRepository})
      : super(
          const HomeState(
              searchMode: false,
              searchResult: '',
              authKey: false,
              showBookmarked: false),
        );

  void enterSearchMode() {
    emit(
      HomeState(
        searchMode: true,
        searchResult: '',
        authKey: state.authKey,
        showBookmarked: state.showBookmarked,
      ),
    );
  }

  void searchControll(String value) {
    emit(
      HomeState(
        searchMode: state.searchMode,
        searchResult: value,
        authKey: state.authKey,
        showBookmarked: state.showBookmarked,
      ),
    );
  }

  void exitSearch() {
    emit(
      HomeState(
        searchResult: '',
        searchMode: false,
        authKey: state.authKey,
        showBookmarked: state.showBookmarked,
      ),
    );
  }

  void showBookmaked() {
    
    emit(
      HomeState(
        searchMode: state.searchMode,
        searchResult: state.searchResult,
        showBookmarked: !state.showBookmarked,
        authKey: state.authKey,
      ),
    );
  }

  void getAuthKey() async {
    final key = await dataBaseRepository.getAuthKey();

    emit(
      HomeState(
        searchMode: state.searchMode,
        searchResult: state.searchResult,
        showBookmarked: state.showBookmarked,
        authKey: key ?? false,
      ),
    );
  }

  void setAuthKey(bool key) {
    dataBaseRepository.setAuthKey(key);

    emit(
      HomeState(
        searchResult: '',
        searchMode: false,
        authKey: key,
        showBookmarked: state.showBookmarked,
      ),
    );
  }
}
