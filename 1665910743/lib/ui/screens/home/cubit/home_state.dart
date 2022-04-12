part of 'home_cubit.dart';

@immutable
class HomeState {
  final bool searchMode;
  final String searchResult;
  final bool authKey;

  HomeState({
    required this.searchMode,
    required this.searchResult,
    required this.authKey,
  });
}
