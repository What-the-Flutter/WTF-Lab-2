import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../repository/database_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  DataBaseRepository dataBaseRepository;

  HomeCubit({required this.dataBaseRepository})
      : super(HomeState(
          searchMode: false,
          searchResult: '',
          authKey: false,
        ));

  void enterSearchMode() {
    emit(
      HomeState(
        searchMode: true,
        searchResult: '',
        authKey: state.authKey,
      ),
    );
  }

  void searchControll(String value) {
    emit(
      HomeState(
        searchMode: state.searchMode,
        searchResult: value,
        authKey: state.authKey,
      ),
    );
  }

  void exitSearch() {
    emit(
      HomeState(
        searchResult: '',
        searchMode: false,
        authKey: state.authKey,
      ),
    );
  }

  void getAuthKey() async {
    final key = await dataBaseRepository.getAuthKey();

    emit(
      HomeState(
        searchMode: false,
        searchResult: '',
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
      ),
    );
  }
}
