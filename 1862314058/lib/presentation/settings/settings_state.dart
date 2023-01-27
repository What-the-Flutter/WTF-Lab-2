import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../repository/shared_pref_app.dart';

part 'settings_cubit.dart';

class SettingsState {
  final bool isBubbleAlignment;
  final bool isCenterDateBubble;
  final String backgroundImage;

  SettingsState({
    required this.isBubbleAlignment,
    required this.isCenterDateBubble,
    required this.backgroundImage,
  });

  SettingsState copyWith({
    bool? isBubbleAlignment,
    bool? isCenterDateBubble,
    String? backgroundImage,
  }) {
    return SettingsState(
      isBubbleAlignment: isBubbleAlignment ?? this.isBubbleAlignment,
      isCenterDateBubble: isCenterDateBubble ?? this.isCenterDateBubble,
      backgroundImage: backgroundImage ?? this.backgroundImage,
    );
  }

}
