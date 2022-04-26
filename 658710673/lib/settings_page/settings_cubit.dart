import 'package:bloc/bloc.dart';

import '../utils/theme/app_theme.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit()
      : super(
          SettingsState(
            theme: AppTheme.lightTheme,
            useBiometrics: false,
          ),
        );

  void resetSettings() {
    emit(
      state.copyWith(
        theme: AppTheme.lightTheme,
        useBiometrics: false,
      ),
    );
  }
}
