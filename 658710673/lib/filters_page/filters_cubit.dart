import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/category.dart';
import '../../models/filter_parameters.dart';
import '../data/firebase_provider.dart';
import 'filters_state.dart';

class FiltersPageCubit extends Cubit<FiltersPageState> {
  final User? _user;
  late final FirebaseProvider _db = FirebaseProvider(user: _user);

  FiltersPageCubit({required User? user})
      : _user = user,
        super(
          FiltersPageState(
            eventPages: [],
            parameters: FilterParameters(
              selectedPagesId: [],
              searchText: '',
            ),
          ),
        );

  void init() {
    showCategories();
  }

  void showCategories() async {
    final pages = await _db.getAllCategories();
    emit(state.copyWith(eventPages: pages));
  }

  void onPagePressed(Category page) {
    isPageSelected(page) ? unselectPage(page) : selectPage(page);
  }

  bool isPageSelected(Category page) {
    return state.parameters.selectedPagesId.contains(page.id);
  }

  void selectPage(Category page) {
    final pages = state.parameters.selectedPagesId;
    pages.add(page.id!);
    final parameters = state.parameters.copyWith(selectedPagesId: pages);
    emit(state.copyWith(parameters: parameters));
  }

  void unselectPage(Category page) {
    final pages = state.parameters.selectedPagesId;
    pages.remove(page.id);
    final parameters = state.parameters.copyWith(selectedPagesId: pages);
    emit(state.copyWith(parameters: parameters));
  }

  String pagesInfo() {
    String info;
    if (state.parameters.selectedPagesId.isEmpty) {
      info =
          'Tap to select a page you want to include to the filter. All pages are included by default';
    } else {
      info = '${state.parameters.selectedPagesId.length} page(s) included';
    }
    return info;
  }

  void setSearchText(String text) {
    final parameters = state.parameters.copyWith(searchText: text);
    emit(state.copyWith(parameters: parameters));
  }
}
