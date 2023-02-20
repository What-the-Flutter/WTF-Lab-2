import 'package:bloc_test/bloc_test.dart';
import 'package:diary/presentation/settings/cubit/settings_cubit/settings_cubit.dart';
import 'package:diary/presentation/settings/theme.dart';
import 'package:diary/repo/setting_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

void main() async {
  late SettingsCubit settingsCubit;

  setUp(() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    final sharedPreferences = await SharedPreferences.getInstance();
    settingsCubit =
        SettingsCubit(SettingsRepository(preferences: sharedPreferences));
  });

  group('Settings repository', () {
    blocTest(
      'Text alignment test',
      build: () => settingsCubit,
      seed: () => SettingsState(),
      act: (cubit) {
        cubit.changeAlignment();
        cubit.changeAlignment();
      },
      expect: () => <dynamic>[
        SettingsState(
          bubbleAlignment: BubbleAlignment.right,
        ),
        SettingsState(
          bubbleAlignment: BubbleAlignment.left,
        ),
      ],
    );

    blocTest(
      'Text size test',
      build: () => settingsCubit,
      seed: () => SettingsState(),
      act: (cubit) {
        cubit.changeTextSize(TextSizeKeys.large);
        cubit.changeTextSize(TextSizeKeys.small);
        cubit.changeTextSize(TextSizeKeys.medium);
      },
      expect: () => <dynamic>[
        SettingsState(
          textSize: TextSizeKeys.large,
        ),
        SettingsState(
          textSize: TextSizeKeys.small,
        ),
        SettingsState(
          textSize: TextSizeKeys.medium,
        ),
      ],
    );

    blocTest(
      'Date alignment test',
      build: () => settingsCubit,
      seed: () => SettingsState(),
      act: (cubit) {
        cubit.changeDateBubbleAlignment();
        cubit.changeDateBubbleAlignment();
      },
      expect: () => <dynamic>[
        SettingsState(
          isCenterDateAlignment: false,
        ),
        SettingsState(
          isCenterDateAlignment: true,
        ),
      ],
    );

    blocTest(
      'To default test',
      build: () => settingsCubit,
      seed: () => SettingsState(
        bubbleAlignment: BubbleAlignment.right,
        textSize: TextSizeKeys.large,
        isCenterDateAlignment: false,
        themeMode: ThemeMode.dark,
      ),
      act: (cubit) {
        cubit.toDefaultSettings();
      },
      expect: () => <dynamic>[
        SettingsState(),
      ],
    );

    test('Theme mode value should be ', () {
      var themeMode = settingsCubit.state.themeMode;
      themeMode = themeMode.name == 'light' ? ThemeMode.dark : ThemeMode.light;
      settingsCubit.changeTheme();
      final res = settingsCubit.state.themeMode;
      expect(res, themeMode);
    });
  });
}
