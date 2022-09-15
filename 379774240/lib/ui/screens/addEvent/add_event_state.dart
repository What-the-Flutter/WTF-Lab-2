part of 'add_event_cubit.dart';

class AddEventState extends Equatable {
  final int? selectedIcon;
  final String eventName;
  final List<IconData> icons;

  AddEventState({
    this.selectedIcon,
    this.eventName = '',
    this.icons = const [
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
        eventName,
        icons,
      ];

  AddEventState copyWith({
    int? selectedIcon,
    String? eventName,
    List<IconData>? icons,
  }) {
    return AddEventState(
      selectedIcon: selectedIcon ?? this.selectedIcon,
      eventName: eventName ?? this.eventName,
      icons: icons ?? this.icons,
    );
  }
}
