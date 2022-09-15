part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  final bool isDarkTheme;
  final bool isMessageLeftAlign;
  final bool isDateBubbleHiden;
  final double fontSize;

  const SettingsState({
    required this.isDarkTheme,
    required this.isMessageLeftAlign,
    required this.isDateBubbleHiden,
    required this.fontSize,
  });

  @override
  List<Object> get props => [
        isDarkTheme,
        isMessageLeftAlign,
        isDateBubbleHiden,
        fontSize,
      ];

  SettingsState copyWith({
    bool? isDarkTheme,
    bool? isMessageLeftAlign,
    bool? isDateBubbleHiden,
    double? fontSize,
  }) {
    return SettingsState(
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
      isMessageLeftAlign: isMessageLeftAlign ?? this.isMessageLeftAlign,
      isDateBubbleHiden: isDateBubbleHiden ?? this.isDateBubbleHiden,
      fontSize: fontSize ?? this.fontSize,
    );
  }
}
