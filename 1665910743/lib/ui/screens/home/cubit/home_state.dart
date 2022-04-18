part of 'home_cubit.dart';

class HomeState {
  final bool searchMode;
  final String searchResult;
  final bool authKey;
  final bool showBookmarked;

  const HomeState( {
    required this.searchMode,
    required this.searchResult,
    required this.authKey,
    required this.showBookmarked,
  });
}
