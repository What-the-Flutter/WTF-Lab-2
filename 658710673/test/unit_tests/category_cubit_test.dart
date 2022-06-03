import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:chat_journal/category_page/category_cubit.dart';
import 'package:chat_journal/category_page/category_state.dart';
import 'package:chat_journal/models/filter_parameters.dart';
import 'package:chat_journal/models/event.dart';

void main() {
  late CategoryCubit categoryCubit;

  final user = MockUser(
    isAnonymous: true,
  );

  final category1EventsList = [
    Event(
      description: '1',
      category: 1,
    ),
    Event(
      description: '3',
      category: 1,
    ),
  ];

  final category2EventsList = [
    Event(
      description: '2',
      category: 2,
    ),
    Event(
      description: '4',
      category: 2,
    ),
  ];

  setUp(() {
    WidgetsFlutterBinding.ensureInitialized();
    categoryCubit = CategoryCubit(user: user);
  });

  group("CategoryCubit tests", () {
    blocTest<CategoryCubit, CategoryState>(
      'Add category',
      build: () => categoryCubit,
      seed: () => CategoryState(
        events: category1EventsList + category2EventsList,
        searchedEvents: [],
        filteredEvents: [],
      ),
      act: (cubit) {
        cubit.applyFilters(
          FilterParameters(
            selectedPagesId: [1],
            searchText: '',
          ),
        );
      },
      expect: () => <dynamic>[
        CategoryState(
          events: category1EventsList + category2EventsList,
          searchedEvents: [],
          filteredEvents: category1EventsList,
        ),
      ],
    );

    blocTest<CategoryCubit, CategoryState>(
      'Changing editing mode',
      build: () => categoryCubit,
      seed: () => CategoryState(
        events: [],
        searchedEvents: [],
        filteredEvents: [],
        isFavoriteMode: false,
        isSearchMode: false,
        isEditingMode: false,
        isWritingMode: false,
        isMessageEdit: false,
        isAttachment: false,
      ),
      act: (cubit) {
        cubit.changeEditingMode();
      },
      expect: () => <dynamic>[
        CategoryState(
          events: [],
          searchedEvents: [],
          filteredEvents: [],
          isEditingMode: true,
        ),
      ],
    );
  });
}
