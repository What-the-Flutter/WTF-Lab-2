import 'package:flutter/material.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/Users/macbook/Dev/wtflab2/WTF-Lab-2/1665910743/lib/ui/theme/theme_cubit/theme_cubit.dart';
import '/Users/macbook/Dev/wtflab2/WTF-Lab-2/1665910743/lib/ui/theme/theme_data.dart';

void main() {
  group('theme', () {
    late ThemeCubit themeCubit;

    setUp(() {
      WidgetsFlutterBinding.ensureInitialized();
      themeCubit = ThemeCubit(MyThemes.lightTheme);
    });

    blocTest<ThemeCubit, ThemeData>(
      'change theme',
      setUp: () => SharedPreferences.setMockInitialValues({}),
      build: () => themeCubit,
      act: (cubit) => cubit.themeChanged(MyThemeKeys.dark),
      expect: () => [MyThemes.darkTheme],
    );
  });
}
