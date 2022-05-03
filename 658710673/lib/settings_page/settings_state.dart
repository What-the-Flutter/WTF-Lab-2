class SettingsState {
  final double fontSize;
  final bool isBubbleChatLeft;
  final bool isDateCenterAlign;
  final bool isLocalAuth;
  final String backgroundImagePath;

  SettingsState({
    required this.fontSize,
    this.isBubbleChatLeft = true,
    this.isDateCenterAlign = false,
    this.isLocalAuth = false,
    this.backgroundImagePath = '',
  });

  SettingsState copyWith({
    double? fontSize,
    bool? isBubbleChatLeft,
    bool? isDateCenterAlign,
    bool? isLocalAuth,
    String? backgroundImagePath,
  }) {
    return SettingsState(
      fontSize: fontSize ?? this.fontSize,
      isBubbleChatLeft: isBubbleChatLeft ?? this.isBubbleChatLeft,
      isDateCenterAlign: isDateCenterAlign ?? this.isDateCenterAlign,
      isLocalAuth: isLocalAuth ?? this.isLocalAuth,
      backgroundImagePath: backgroundImagePath ?? this.backgroundImagePath,
    );
  }
}
