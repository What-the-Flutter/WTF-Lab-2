import 'package:equatable/equatable.dart';

import '../../models/filter_parameters.dart';
import '../models/category.dart';

class FiltersPageState extends Equatable {
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

  @override
  List<Object?> get props => [eventPages, parameters];
}
