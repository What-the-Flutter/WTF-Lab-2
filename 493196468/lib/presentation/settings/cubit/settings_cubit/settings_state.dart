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


