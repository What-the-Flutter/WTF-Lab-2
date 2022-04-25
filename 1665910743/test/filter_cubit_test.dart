import 'package:flutter/material.dart';
import 'package:test/test.dart';
import '/Users/macbook/Dev/wtflab2/WTF-Lab-2/1665910743/lib/ui/screens/timeline_screen/cubit/filter_cubit.dart';
import 'package:bloc_test/bloc_test.dart';

void main() {
  late FilterCubit filterCubit;

  setUp(() {
    WidgetsFlutterBinding.ensureInitialized();
    filterCubit = FilterCubit();
  });

  group("Filter test", () {
    blocTest<FilterCubit, List<String>>(
      'Add strings to filter',
      build: () => filterCubit,
      act: (cubit) {
        cubit.addCategoryFromFilter('Test');
        cubit.addCategoryFromFilter('Test2');
      },
      expect: () => [
        ['Test', 'Test2']
      ],
    );

    blocTest<FilterCubit, List<String>>(
      'Add strings to filter and reset',
      build: () => filterCubit,
      act: (cubit) {
        cubit.addCategoryFromFilter('Test');
        cubit.addCategoryFromFilter('Test2');
        cubit.reset();
      },
      expect: () => [[]],
    );
  });
}
