import '../../models/filter_parameters.dart';
import '../models/category.dart';

class FiltersPageState {
  final List<Category> eventPages;
  final FilterParameters parameters;

  FiltersPageState({
    required this.eventPages,
    required this.parameters,
  });

  FiltersPageState copyWith({
    List<Category>? eventPages,
    FilterParameters? parameters,
  }) {
    return FiltersPageState(
      eventPages: eventPages ?? this.eventPages,
      parameters: parameters ?? this.parameters,
    );
  }
}
