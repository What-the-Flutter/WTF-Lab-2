part of 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final SharedPreferences _prefs;

  ThemeCubit(this._prefs) : super(ThemeState()) {}

  void init() {
    emit(state.copyWith(isLightTheme: _loadTheme()));
    setFontSizeText(_loadFontSize());
  }

  bool _loadTheme() => _prefs.getBool('light_theme') ?? true;

  void updateTheme() {
    final updateThemeApp =
        state.isLightTheme! ? state.lightTheme : state.darkTheme;
    emit(updateThemeApp);
  }

  void changeTheme() {
    emit(state.copyWith(isLightTheme: !state.isLightTheme!));
    // if (state.appThemes == ThemeState.lightTheme) {
    //   emit(
    //     ThemeState.darkTheme(),
    //   );
    // } else {
    //   emit(
    //     ThemeState.lightTheme(),
    //   );
    // }
    _prefs.setBool(
      'light_theme',
      state.isLightTheme!,
    );
    updateTheme();
  }

  int _loadFontSize() => _prefs.getInt('font_size_app') ?? 2;

  setFontSizeText(int fontSizeIndex) {
    switch (fontSizeIndex) {
      case 1:
        emit(
          state.copyWith(textTheme: ThemeState.smallTextTheme),
        );
        break;
      case 2:
        emit(
          state.copyWith(textTheme: ThemeState.defaultTextTheme),
        );
        break;
      case 3:
        emit(
          state.copyWith(textTheme: ThemeState.largeTextTheme),
        );
        break;
    }
    _prefs.setInt(
      'font_size_app',
      fontSizeIndex,
    );
    updateTheme();
  }

  void resetAllPreferences() {
    _prefs.setInt('font_size_app', 2);
    _prefs.setBool('light_theme', true);
    init();
  }
}
