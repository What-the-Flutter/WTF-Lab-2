import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesServices {
  static SharedPreferencesServices? _sharedPreferencesServices;
  static SharedPreferences? _prefs;

  SharedPreferencesServices._createInit();

  factory SharedPreferencesServices() =>
      _sharedPreferencesServices ??= SharedPreferencesServices._createInit();

  static initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool loadTheme() => _prefs!.getBool('light_theme') ?? true;

  void changeTheme(bool isLightTheme) {
    _prefs!.setBool(
      'light_theme',
      isLightTheme,
    );
  }

  int loadFontSize() => _prefs!.getInt('font_size_app') ?? 2;

  void changeFontSizeText(int fontSizeIndex) {
    _prefs!.setInt(
      'font_size_app',
      fontSizeIndex,
    );
  }

  void resetAllPreferences() {
    _prefs!.setInt('font_size_app', 2);
    _prefs!.setBool('light_theme', true);
    _prefs!.setBool('is_bubble', false);
  }

  bool loadCenterAlignment() => _prefs!.getBool('is_center_alignment') ?? false;

  void changeCenterAlignment(bool isCenterDateBubble) {
    _prefs!.setBool(
      'is_center_alignment',
      isCenterDateBubble,
    );
  }

  bool loadBubbleAlignment() => _prefs!.getBool('is_bubble') ?? false;

  void changeBubbleAlignment(bool isBubbleAlignment) {
    _prefs!.setBool(
      'is_bubble',
      isBubbleAlignment,
    );
  }

  String loadBackgroundImage() => _prefs!.getString('background_image') ?? 'nothing';

  void updateBackgroundImage(String backImage) {
    _prefs!.setString(
      'background_image',
      backImage,
    );
  }

  void deleteBackgroundImage() {
    _prefs!.remove('background_image');
  }
}
