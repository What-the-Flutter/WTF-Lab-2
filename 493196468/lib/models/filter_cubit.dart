

import 'package:bloc/bloc.dart';

class FilterCubit extends  Cubit<Filter> {
  FilterCubit() : super(Filter(false, ''));

  void setFilter(String filter) => emit(Filter(true, filter));

  void deleteFilter() => emit(Filter(false, ''));

  bool isFiltered() => state.isFiltered;
}

class Filter {
  final bool isFiltered;
  final String filter;

  Filter(this.isFiltered, this.filter);
}
