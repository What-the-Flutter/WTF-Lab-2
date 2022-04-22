part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  final Alignment chatTileAlignment;
  final String backgroundImagePath;

  SettingsState({
    required this.chatTileAlignment,
    this.backgroundImagePath = '',
  });

  SettingsState copyWith({
    Alignment? chatTileAlignment,
    String? backgroundImagePath,
  }) {
    return SettingsState(
      chatTileAlignment: chatTileAlignment ?? this.chatTileAlignment,
      backgroundImagePath: backgroundImagePath ?? this.backgroundImagePath,
    );
  }

  @override
  List<Object?> get props => [chatTileAlignment, backgroundImagePath];
}
