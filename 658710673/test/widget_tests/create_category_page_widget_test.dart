import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:chat_journal/create_category_page/create_category_cubit.dart';
import 'package:chat_journal/create_category_page/create_category_page.dart';
import 'package:chat_journal/create_category_page/create_category_state.dart';

class MockCreateCategoryPageCubit extends MockCubit<CreateCategoryPageState>
    implements CreateCategoryPageCubit {}

class FakeCreateCategoryPageState extends Fake implements CreateCategoryPageState {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeCreateCategoryPageState());
  });

  group('CreateCategoryPage', () {
    late CreateCategoryPageCubit cubit;

    setUp(() {
      cubit = MockCreateCategoryPageCubit();
    });

    testWidgets('Load Widgets', (tester) async {
      when(() => cubit.state).thenReturn(
        CreateCategoryPageState(
          selectedIcon: 0,
        ),
      );
      final page = BlocProvider<CreateCategoryPageCubit>.value(
        value: cubit,
        child: const MaterialApp(
          home: const CreateCategoryPage(),
        ),
      );
      await tester.pumpWidget(page);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byType(GridTile), findsNWidgets(12));
    });

    testWidgets('Input TextField', (tester) async {
      when(() => cubit.state).thenReturn(
        CreateCategoryPageState(
          selectedIcon: 0,
        ),
      );
      final page = BlocProvider<CreateCategoryPageCubit>.value(
        value: cubit,
        child: const MaterialApp(
          home: const CreateCategoryPage(),
        ),
      );
      await tester.pumpWidget(page);
      await tester.enterText(find.byType(TextField), 'Random text');
      expect(find.text('Random text'), findsOneWidget);
    });

    testWidgets('Tap CircleAvatar', (tester) async {
      when(() => cubit.state).thenReturn(
        CreateCategoryPageState(
          selectedIcon: 0,
        ),
      );
      final page = BlocProvider<CreateCategoryPageCubit>.value(
        value: cubit,
        child: const MaterialApp(
          home: const CreateCategoryPage(),
        ),
      );
      await tester.pumpWidget(page);
      await tester.tap(find.byType(CircleAvatar).first);
      verify(() => cubit.selectIcon(any())).called(1);
    });
  });
}
