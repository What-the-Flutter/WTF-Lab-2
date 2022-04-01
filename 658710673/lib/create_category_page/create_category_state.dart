class CreateCategoryPageState {
  int selectedIcon;

  CreateCategoryPageState({this.selectedIcon = 0});

  CreateCategoryPageState copyWith({
    int? index,
  }) {
    return CreateCategoryPageState(
      selectedIcon: index ?? selectedIcon,
    );
  }
}
