import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_cubit.dart';

class SettingsState {
  final bool? isBubbleAlignment;
  final bool? isCenterDateBubble;

  SettingsState({
    this.isBubbleAlignment,
    this.isCenterDateBubble,
  });

  SettingsState copyWith({
    bool? isBubbleAlignment,
    bool? isCenterDateBubble,
  }) {
    return SettingsState(
      isBubbleAlignment: isBubbleAlignment ?? this.isBubbleAlignment,
      isCenterDateBubble: isCenterDateBubble ?? this.isCenterDateBubble,
    );
  }

}
