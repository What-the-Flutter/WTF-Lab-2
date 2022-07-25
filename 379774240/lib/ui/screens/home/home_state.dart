part of 'home_cubit.dart';

class HomeState extends Equatable {
  final models.PageController pageController;
  final List<Event> events;
  final AppState appState;

  const HomeState({
    required this.pageController,
    this.events = const [],
    required this.appState,
  });

  @override
  List<Object> get props => [
        pageController,
        events,
        appState,
      ];

  HomeState copyWith({
    models.PageController? pageController,
    List<Event>? events,
    AppState? appState,
  }) {
    return HomeState(
      pageController: pageController ?? this.pageController,
      events: events ?? this.events,
      appState: appState ?? this.appState,
    );
  }
}
