part of 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SharedPreferences _prefs;

  SettingsCubit(this._prefs) : super(SettingsState());

  void init() {
    emit(
      state.copyWith(
        isBubbleAlignment: _loadBubbleAlignment(),
        isCenterDateBubble: _loadCenterAlignment(),
      ),
    );
  }

  bool _loadCenterAlignment() => _prefs.getBool('is_center_alignment') ?? false;

  bool _loadBubbleAlignment() => _prefs.getBool('is_bubble') ?? false;

  void changeBubbleAlignment() {
    emit(
      state.copyWith(
        isBubbleAlignment: !state.isBubbleAlignment!,
      ),
    );
    _prefs.setBool(
      'is_bubble',
      state.isBubbleAlignment!,
    );
  }

  void changeCenterDateBubble() {
    emit(
      state.copyWith(
        isCenterDateBubble: !state.isCenterDateBubble!,
      ),
    );
    _prefs.setBool(
      'is_center_alignment',
      state.isCenterDateBubble!,
    );
  }
}
