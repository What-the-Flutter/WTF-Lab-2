import 'package:equatable/equatable.dart';

class FilterParameters extends Equatable {
  final List<int> selectedPagesId;
  final String searchText;

  FilterParameters({
    required this.selectedPagesId,
    required this.searchText,
  });

  FilterParameters copyWith({
    List<int>? selectedPagesId,
    String? searchText,
  }) {
    return FilterParameters(
      selectedPagesId: selectedPagesId ?? this.selectedPagesId,
      searchText: searchText ?? this.searchText,
    );
  }

  @override
  List<Object?> get props => [selectedPagesId, searchText];
}
