import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chat_app/presentation/home/home_state.dart';
import 'package:chat_app/presentation/home/add_post_page.dart';

class MockAddPostPageCubit extends MockCubit<HomeState> implements HomeCubit {}

class FakeAddPostPageState extends Fake implements HomeState {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeAddPostPageState());
  });

  group(
    'Add Post Widget tests',
    () {
      late HomeCubit cubit;
      setUp(() {
        cubit = MockAddPostPageCubit();
      });

      testWidgets(
        'Load Page',
        (tester) async {
          when(() => cubit.state).thenReturn(
            HomeState(),
          );
          final page = BlocProvider<HomeCubit>.value(
            value: cubit,
            child: const MaterialApp(
              home: const AddPostPage(
                isEditMode: false,
              ),
            ),
          );

          await tester.pumpWidget(page);
          expect(find.byType(TextField), findsOneWidget);
          expect(find.byType(FloatingActionButton), findsOneWidget);
        },
      );

      testWidgets(
        'Input TextField',
        (tester) async {
          when(() => cubit.state).thenReturn(
            HomeState(),
          );
          final page = BlocProvider<HomeCubit>.value(
            value: cubit,
            child: const MaterialApp(
              home: const AddPostPage(
                isEditMode: false,
              ),
            ),
          );
          await tester.pumpWidget(page);
          await tester.enterText(find.byType(TextField), 'Test text');
          expect(find.text('Test text'), findsOneWidget);
        },
      );
    },
  );
}
