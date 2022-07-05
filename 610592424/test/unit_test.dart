import 'package:bloc_test/bloc_test.dart';
import 'package:diploma/models/event.dart';
import 'package:diploma/settings_page/settings_cubit.dart';
import 'package:diploma/settings_page/settings_state.dart';
import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
void main() {
  group("SettingsCubit tests", () {
    blocTest<SettingsCubit, SettingsState>(
      'Change textTheme',
      build: () => SettingsCubit(),
      seed: () => SettingsState(
        currentTheme: ThemeData(),
        textTheme: SettingsState.medium,
        bubbleAlignment: false,
        centerDate: false,
      ),
      act: (cubit) {
        cubit.initTextTheme(0);
      },
      expect: () => <dynamic>[
        SettingsState(
          currentTheme: ThemeData(),
          textTheme: SettingsState.small,
          bubbleAlignment: false,
          centerDate: false,
        ),
      ],
    );

    blocTest<SettingsCubit, SettingsState>(
      'Change bubble alignment',
      build: () => SettingsCubit(),
      seed: () => SettingsState(
        currentTheme: ThemeData(),
        textTheme: SettingsState.medium,
        bubbleAlignment: false,
        centerDate: false,
      ),
      act: (cubit) {
        cubit.changeAlignment();
      },
      expect: () => <dynamic>[
        SettingsState(
          currentTheme: ThemeData(),
          textTheme: SettingsState.medium,
          bubbleAlignment: true,
          centerDate: false,
        ),
      ],
    );

    blocTest<SettingsCubit, SettingsState>(
      'Change central date',
      build: () => SettingsCubit(),
      seed: () => SettingsState(
        currentTheme: ThemeData(),
        textTheme: SettingsState.medium,
        bubbleAlignment: false,
        centerDate: false,
      ),
      act: (cubit) {
        cubit.changeCenterDate();
      },
      expect: () => <dynamic>[
        SettingsState(
          currentTheme: ThemeData(),
          textTheme: SettingsState.medium,
          bubbleAlignment: false,
          centerDate: true,
        ),
      ],
    );
  });

  group("Event model tests", () {
    test('Copy event with new text', () {
      final event = Event(1, '', 2);

      expect(event.copyWith(text: 'newText'),Event(1, 'newText', 2));
    });

    test('Event to map', () {
      final time = DateTime.now();
      final event = Event(1, 'text', 2, 0, '', time);

      expect(event.toMap(leavePrevDate: true), {
        'event_id': 1,
        'iconIndex': 0,
        'text': 'text',
        'eventholder_id': 2,
        'image_path': '',
        'time_of_creation': time.toIso8601String(),
      });
    });
  });
}