import 'package:test/test.dart';
import '/Users/macbook/Dev/wtflab2/WTF-Lab-2/1665910743/lib/ui/screens/settings/cubit/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('settings', () {
    late SettingsCubit settingsCubit;

    setUp(() {
      WidgetsFlutterBinding.ensureInitialized();
      settingsCubit = SettingsCubit(
        alignRight: false,
        image: '',
      );
    });

    blocTest<SettingsCubit, SettingsState>(
      'change alignment',
      setUp: () => SharedPreferences.setMockInitialValues({}),
      build: () => settingsCubit,
      act: (cubit) => cubit.alignmentRight(),
      expect: () => [SettingsState(chatTileAlignment: Alignment.centerRight)],
    );

    blocTest<SettingsCubit, SettingsState>(
      'change backGroundImage',
      setUp: () => SharedPreferences.setMockInitialValues({}),
      build: () => settingsCubit,
      act: (cubit) => cubit.alignmentRight(),
      expect: () => [SettingsState(chatTileAlignment: Alignment.centerRight)],
    );
  });
}
