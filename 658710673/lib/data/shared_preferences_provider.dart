import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';
import '../utils/theme/app_theme.dart';

class SharedPreferencesProvider {
  static SharedPreferencesProvider? _sharedPreferencesProvider;
  static late SharedPreferences _prefs;

  SharedPreferencesProvider._createInstance();

  factory SharedPreferencesProvider() =>
      _sharedPreferencesProvider ??= SharedPreferencesProvider._createInstance();

  static Future<void> initialize() async => _prefs = await SharedPreferences.getInstance();

  void changeLocalAuth(bool isLocalAuth) => _prefs.setBool('localAuth', isLocalAuth);

  bool fetchLocalAuth() => _prefs.getBool('localAuth') ?? false;

  void changeFontSize(double fontSize) => _prefs.setDouble('fontSize', fontSize);

  double fetchFontSize() =>
      _prefs.getDouble('fontSize') ?? FontSizes.fontSizes[FontSizeKeys.medium]!;

  void changeTheme(ThemeKeys theme) => _prefs.setString('theme', theme.toString());

  String fetchTheme() => _prefs.getString('theme') ?? ThemeKeys.light.toString();

  void changeBubbleAlignment(bool isBubbleAlignment) =>
      _prefs.setBool('isBubbleAlignment', isBubbleAlignment);

  bool fetchBubbleAlignment() => _prefs.getBool('isBubbleAlignment') ?? false;

  void changeCenterDateBubble(bool isCenterDateBubble) =>
      _prefs.setBool('isCenterDateBubble', isCenterDateBubble);

  bool fetchCenterDateBubble() => _prefs.getBool('isCenterDateBubble') ?? false;

  void changeBgImage(String imagePath) => _prefs.setString('backgroundImage', imagePath);

  String fetchBgImage() => _prefs.getString('backgroundImage') ?? '';
}
