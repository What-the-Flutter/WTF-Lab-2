part of 'home_cubit.dart';

class HomeState extends Equatable {
  final models.PageController pageController;
  final List<Event> events;

  const HomeState({
    required this.pageController,
    this.events = const [],
  });

  @override
  List<Object> get props => [
        pageController,
        events,
      ];

  HomeState copyWith({
    models.PageController? pageController,
    List<Event>? events,
  }) {
    return HomeState(
      pageController: pageController ?? this.pageController,
      events: events ?? this.events,
    );
  }
}
