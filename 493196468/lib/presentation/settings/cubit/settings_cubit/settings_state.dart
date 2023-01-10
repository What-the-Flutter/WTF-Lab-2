part of 'settings_cubit.dart';

enum BubbleAlignment {
  left,
  right,
}

class SettingsState extends Equatable {
  final ThemeMode themeMode;
  final TextSizeKeys textSize;
  final BubbleAlignment bubbleAlignment;
  final bool isCenterDateAlignment;

  SettingsState({
    this.isCenterDateAlignment = true,
    this.textSize = TextSizeKeys.medium,
    this.bubbleAlignment = BubbleAlignment.left,
    this.themeMode = ThemeMode.light,
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    TextSizeKeys? textSize,
    BubbleAlignment? bubbleAlignment,
    bool? isCenterDateAlignment,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      bubbleAlignment: bubbleAlignment ?? this.bubbleAlignment,
      textSize: textSize ?? this.textSize,
      isCenterDateAlignment: isCenterDateAlignment ?? this.isCenterDateAlignment,
    );
  }

  @override
  List<Object?> get props => [themeMode, textSize, bubbleAlignment, isCenterDateAlignment];
}

class ThemePreferences {
  static const _themeMode = 'themeMode';

  Future saveTheme(ThemeMode themeMode) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString(_themeMode, themeMode.name);
  }

  Future<ThemeMode> getTheme() async {
    final preferences = await SharedPreferences.getInstance();
    final themeMode = preferences.getString(_themeMode);
    if (themeMode == null) {
      return ThemeMode.system;
    }
    return themeMode == 'light' ? ThemeMode.light : ThemeMode.dark;
  }
}

class AlignmentPreferences {
  static const _bubbleAlignment = 'bubbleAlignment';

  Future saveAlignment(BubbleAlignment bubbleAlignment) async {
    final preferences = await SharedPreferences.getInstance();
    final alignmentStr =
        BubbleAlignment.left == bubbleAlignment ? 'left' : 'right';
    preferences.setString(_bubbleAlignment, alignmentStr);
  }

  Future<BubbleAlignment> getAlignment() async {
    final preferences = await SharedPreferences.getInstance();
    final alignmentStr = preferences.getString(_bubbleAlignment);
    if (alignmentStr == null) {
      return BubbleAlignment.left;
    }
    return alignmentStr == 'left'
        ? BubbleAlignment.left
        : BubbleAlignment.right;
  }
}

class CenterDateAlignmentPreferences {
  static const _centerDateAlignment = 'centerDateAlignment';

  Future saveAlignment(bool isCenterAlignment) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setBool(_centerDateAlignment, isCenterAlignment);
  }

  Future<bool> getAlignment() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_centerDateAlignment) ?? true;
  }
}

class TextSizePreferences {
  static const _textSize = 'textSize';

  void saveTextSize(TextSizeKeys textSize) async {
    final preferences = await SharedPreferences.getInstance();
    final String textSizeStr;
    switch (textSize) {
      case TextSizeKeys.small:
        textSizeStr = 'small';
        break;
      case TextSizeKeys.medium:
        textSizeStr = 'medium';
        break;
      case TextSizeKeys.large:
        textSizeStr = 'large';
        break;
    }
    preferences.setString(_textSize, textSizeStr);
  }

  Future<TextSizeKeys> getFontSize() async {
    final preferences = await SharedPreferences.getInstance();
    switch (preferences.getString(_textSize)) {
      case 'small':
        return TextSizeKeys.small;
      case 'medium':
        return TextSizeKeys.medium;
      case 'large':
        return TextSizeKeys.large;
      default:
        return TextSizeKeys.medium;
    }
  }
}
