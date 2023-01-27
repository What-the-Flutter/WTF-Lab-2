part of 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit()
      : super(
          ThemeState(
            isLightTheme: true,
            textTheme: ThemeState.defaultTextTheme,
            appThemes: ThemeData(),
          ),
        );

  void init() {
    emit(
      state.copyWith(
        isLightTheme: SharedPreferencesServices().loadTheme(),
      ),
    );
    setFontSizeText(
      SharedPreferencesServices().loadFontSize(),
    );
  }

  void updateTheme() {
    final updateThemeApp =
        state.isLightTheme ? state.lightTheme : state.darkTheme;
    emit(updateThemeApp);
  }

  void changeTheme() {
    emit(state.copyWith(isLightTheme: !state.isLightTheme));
    SharedPreferencesServices().changeTheme(state.isLightTheme);
    updateTheme();
  }

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
    SharedPreferencesServices().changeFontSizeText(fontSizeIndex);
    updateTheme();
  }

  void resetAllPreferences() {
    SharedPreferencesServices().resetAllPreferences();
    init();
  }
}
