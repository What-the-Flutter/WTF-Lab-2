import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:chat_journal/filters_page/filters_cubit.dart';
import 'package:chat_journal/filters_page/filters_state.dart';
import 'package:chat_journal/models/category.dart';
import 'package:chat_journal/models/filter_parameters.dart';

void main() {
  late FiltersPageCubit filtersPageCubit;
  final category1 =
      Category(id: 1, title: 'one', icon: Icon(Icons.eleven_mp), timeOfCreation: DateTime.now());
  final category2 =
      Category(id: 2, title: 'two', icon: Icon(Icons.category), timeOfCreation: DateTime.now());
  final user = MockUser(
    isAnonymous: true,
  );

  setUp(() {
    WidgetsFlutterBinding.ensureInitialized();
    filtersPageCubit = FiltersPageCubit(user: user);
  });

  group("FiltersCubit tests", () {
    blocTest<FiltersPageCubit, FiltersPageState>(
      'Add text for searching',
      build: () => filtersPageCubit,
      act: (cubit) {
        cubit.setSearchText('random text');
      },
      expect: () => <dynamic>[
        FiltersPageState(
          eventPages: [],
          parameters: FilterParameters(
            selectedPagesId: [],
            searchText: 'random text',
          ),
        ),
      ],
    );

    blocTest<FiltersPageCubit, FiltersPageState>(
      'Add categories to filter',
      build: () => filtersPageCubit,
      act: (cubit) {
        cubit.selectPage(category1);
        cubit.selectPage(category2);
      },
      expect: () => <dynamic>[
        FiltersPageState(
          eventPages: [],
          parameters: FilterParameters(
            selectedPagesId: [1, 2],
            searchText: '',
          ),
        ),
      ],
    );

    blocTest<FiltersPageCubit, FiltersPageState>(
      'Remove categories from filter',
      build: () => filtersPageCubit,
      act: (cubit) {
        cubit.selectPage(category1);
        cubit.selectPage(category2);
        cubit.unselectPage(category1);
      },
      expect: () => <dynamic>[
        FiltersPageState(
          eventPages: [],
          parameters: FilterParameters(
            selectedPagesId: [2],
            searchText: '',
          ),
        ),
      ],
    );
  });
}
