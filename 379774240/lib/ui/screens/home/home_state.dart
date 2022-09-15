part of 'home_cubit.dart';

@immutable
class HomeState extends Equatable {
  final List<Event> favoriteEvents;
  final List<Event> events;
  final AppState appState;
  final int selectedItemInNavBar;

  HomeState({
    this.favoriteEvents = const [],
    this.events = const [],
    this.appState = const AppState(),
    this.selectedItemInNavBar = 0,
  });

  @override
  List<Object> get props => [
        favoriteEvents,
        events,
        appState,
        selectedItemInNavBar,
      ];

  HomeState copyWith({
    List<Event>? favoriteEvents,
    List<Event>? events,
    AppState? appState,
    int? selectedItemInNavBar,
  }) {
    return HomeState(
      favoriteEvents: favoriteEvents ?? this.favoriteEvents,
      events: events ?? this.events,
      appState: appState ?? this.appState,
      selectedItemInNavBar: selectedItemInNavBar ?? this.selectedItemInNavBar,
    );
  }
}
