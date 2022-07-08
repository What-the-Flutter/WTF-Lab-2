import 'package:equatable/equatable.dart';

class PageController extends Equatable {
  final List<String> pages;
  final int currentPage;

  PageController({
    this.pages = const ['Home', 'Daily', 'Timeline', 'Explore'],
    this.currentPage = 0,
  });

  @override
  List<Object?> get props => [
        pages,
        currentPage,
      ];

  PageController copyWith({
    List<String>? pages,
    int? currentPage,
  }) {
    return PageController(
      pages: pages ?? this.pages,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}
