part of 'category_cubit.dart';

@immutable
class CategoryState {
  final String hint;
  final int? selectedIcon;
  final List<IconData> icons;

  const CategoryState({
    required this.hint,
    required this.selectedIcon,
    required this.icons,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CategoryState &&
        other.hint == hint &&
        other.selectedIcon == selectedIcon &&
        listEquals(other.icons, icons);
  }

  @override
  int get hashCode => hint.hashCode ^ selectedIcon.hashCode ^ icons.hashCode;

  CategoryState copyWith({
    String? hint,
    int? selectedIcon,
    List<IconData>? icons,
  }) {
    return CategoryState(
      hint: hint ?? this.hint,
      selectedIcon: selectedIcon ?? this.selectedIcon,
      icons: icons ?? this.icons,
    );
  }
}

class CategoryInitial extends CategoryState {
  const CategoryInitial({
    super.hint = 'Category name',
    super.selectedIcon,
    super.icons = const [
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
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CategoryInitial &&
        other.hint == hint &&
        other.selectedIcon == selectedIcon &&
        listEquals(other.icons, icons);
  }

  @override
  int get hashCode => hint.hashCode ^ selectedIcon.hashCode ^ icons.hashCode;

  @override
  CategoryInitial copyWith({
    String? hint,
    int? selectedIcon,
    List<IconData>? icons,
  }) {
    return CategoryInitial(
      hint: hint ?? this.hint,
      selectedIcon: selectedIcon ?? this.selectedIcon,
      icons: icons ?? this.icons,
    );
  }
}
