import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';

import '../data/shared_preferences_provider.dart';
import '../utils/constants.dart';
import '../utils/theme/app_theme.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit()
      : super(SettingsState(
          fontSize: FontSizes.fontSizes[FontSizeKeys.medium]!,
        ));

  final _prefs = SharedPreferencesProvider();

  void initSettings() {
    final fontSize = _prefs.fetchFontSize();
    final isBubbleChatLeft = _prefs.fetchBubbleAlignment();
    final isCenterDate = _prefs.fetchCenterDateBubble();
    final isLocalAuth = _prefs.fetchLocalAuth();
    final backgroundImagePath = _prefs.fetchBgImage();

    emit(
      state.copyWith(
        fontSize: fontSize,
        isBubbleChatLeft: isBubbleChatLeft,
        isDateCenterAlign: isCenterDate,
        isLocalAuth: isLocalAuth,
        backgroundImagePath: backgroundImagePath,
      ),
    );
  }

  void changeFontSize(FontSizeKeys size) {
    switch (size) {
      case FontSizeKeys.small:
        emit(state.copyWith(fontSize: FontSizes.fontSizes[FontSizeKeys.small]));
        _prefs.changeFontSize(FontSizes.fontSizes[FontSizeKeys.small]!);
        break;
      case FontSizeKeys.medium:
        emit(state.copyWith(fontSize: FontSizes.fontSizes[FontSizeKeys.medium]));
        _prefs.changeFontSize(FontSizes.fontSizes[FontSizeKeys.medium]!);
        break;
      case FontSizeKeys.large:
        emit(state.copyWith(fontSize: FontSizes.fontSizes[FontSizeKeys.large]));
        _prefs.changeFontSize(FontSizes.fontSizes[FontSizeKeys.large]!);
        break;
    }
  }

  Future<void> share() async {
    final subject = 'Chat Journal';
    final text =
        'Keep track of your life with Chat Journal, a simple and elegant chat-based journal/notes'
        ' application that makes journaling/note-taking fun, easy, quick and effortless.'
        'https://play.google.com/store/apps/details?id=com.agiletelescope.chatjournal';
    await Share.share(text, subject: subject);
  }

  void resetSettings() {
    _prefs.changeFontSize(FontSizes.fontSizes[FontSizeKeys.medium]!);
    _prefs.changeBubbleAlignment(true);
    _prefs.changeCenterDateBubble(false);
    _prefs.changeLocalAuth(false);
    _prefs.changeBgImage('');

    emit(
      state.copyWith(
        fontSize: FontSizes.fontSizes[FontSizeKeys.medium],
        isDateCenterAlign: false,
        isBubbleChatLeft: true,
        isLocalAuth: false,
        backgroundImagePath: '',
      ),
    );
  }

  void changeBubbleAlignment(bool isLeft) {
    emit(state.copyWith(isBubbleChatLeft: isLeft));
    _prefs.changeBubbleAlignment(isLeft);
  }

  void changeCentreDateBubble(bool isCentre) {
    _prefs.changeCenterDateBubble(isCentre);
    emit(state.copyWith(isDateCenterAlign: isCentre));
  }

  void changeLocalAuth(bool isLocalAuth) {
    _prefs.changeLocalAuth(isLocalAuth);
    emit(state.copyWith(isLocalAuth: isLocalAuth));
  }

  Future addBGImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return null;

    emit(state.copyWith(backgroundImagePath: image.path));
    _prefs.changeBgImage(image.path);
  }

  Future resetBGImage() async {
    _prefs.changeBgImage('');
    emit(state.copyWith(backgroundImagePath: ''));
  }

  bool isBackgroundSet() {
    return state.backgroundImagePath == '' ? false : true;
  }
}
