part of 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit()
      : super(
          SettingsState(
            isBubbleAlignment: false,
            isCenterDateBubble: false,
            backgroundImage: '',
          ),
        );

  void init() {
    emit(
      state.copyWith(
        isBubbleAlignment: SharedPreferencesServices().loadBubbleAlignment(),
        isCenterDateBubble: SharedPreferencesServices().loadCenterAlignment(),
        backgroundImage: SharedPreferencesServices().loadBackgroundImage(),
      ),
    );
  }

  void changeBubbleAlignment() {
    emit(
      state.copyWith(
        isBubbleAlignment: !state.isBubbleAlignment,
      ),
    );
    SharedPreferencesServices().changeBubbleAlignment(state.isBubbleAlignment);
  }

  void changeCenterDateBubble() {
    emit(
      state.copyWith(
        isCenterDateBubble: !state.isCenterDateBubble,
      ),
    );
    SharedPreferencesServices().changeCenterAlignment(state.isCenterDateBubble);
  }

  void saveBackgroundImage(String img) {
    emit(
      state.copyWith(backgroundImage: state.backgroundImage),
    );
    SharedPreferencesServices().updateBackgroundImage(img);
    init();
  }

  void deleteBackgroundImage() {
    emit(
      state.copyWith(backgroundImage: state.backgroundImage),
    );
    SharedPreferencesServices().deleteBackgroundImage();
    init();
  }
}
