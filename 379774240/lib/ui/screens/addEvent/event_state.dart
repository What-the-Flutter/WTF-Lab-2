part of 'event_cubit.dart';

class EventState extends Equatable {
  final int? selectedIcon;
  final List<IconData> categoryIocns;
  const EventState({
    this.selectedIcon,
    this.categoryIocns = const [
      Icons.search,
      Icons.home,
      Icons.shopping_cart,
      Icons.delete,
      Icons.description,
      Icons.lightbulb,
      Icons.paid,
      Icons.article,
      Icons.emoji_events,
      Icons.sports_esports,
      Icons.fitness_center,
      Icons.work_outline,
      Icons.spa,
      Icons.celebration,
      Icons.payment,
      Icons.pets,
      Icons.account_balance,
      Icons.savings,
      Icons.family_restroom,
      Icons.crib,
      Icons.music_note,
      Icons.local_bar,
    ],
  });

  @override
  List<Object?> get props => [
        selectedIcon,
        categoryIocns,
      ];

  EventState copyWith({
    int? selectedIcon,
    List<IconData>? categoryIocns,
  }) {
    return EventState(
      selectedIcon: selectedIcon ?? this.selectedIcon,
      categoryIocns: categoryIocns ?? this.categoryIocns,
    );
  }
}
