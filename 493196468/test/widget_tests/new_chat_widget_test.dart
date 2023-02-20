import 'package:bloc_test/bloc_test.dart';
import 'package:diary/presentation/pages/home_page/cubit/home_cubit.dart';
import 'package:diary/presentation/pages/new_chat_page/cubit/new_chat_cubit.dart';
import 'package:diary/presentation/pages/new_chat_page/new_chat_view.dart';
import 'package:diary/presentation/settings/cubit/settings_cubit/settings_cubit.dart';
import 'package:diary/utils/chat_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MocNewChatCubit extends MockCubit<ChatCard> implements NewChatCubit {}

class MocHomeCubit extends MockCubit<ChatsState> implements HomeCubit {}

class MocSettingsCubit extends MockCubit<SettingsState>
    implements SettingsCubit {}

void main() async {
  setUpAll(() {
    registerFallbackValue(const Icon(Icons.add));
  });

  group('CreateCategoryPage', () {
    late MocNewChatCubit cubit;
    late MocHomeCubit homeCubit;
    late MocSettingsCubit settingsCubit;

    setUp(() {
      cubit = MocNewChatCubit();
      homeCubit = MocHomeCubit();
      settingsCubit = MocSettingsCubit();
    });

    testWidgets('Load Elements', (tester) async {
      when(() => cubit.state).thenReturn(
        const ChatCard(
          icon: Icon(
            IconData(0xe481, fontFamily: 'MaterialIcons'),
          ),
          title: '',
        ),
      );
      when(() => homeCubit.state).thenReturn(
        const ChatsState([
          ChatCard(
            icon: Icon(
              IconData(0xe481, fontFamily: 'MaterialIcons'),
            ),
            title: '',
          ),
        ], 0),
      );
      when(() => settingsCubit.state).thenReturn(
        SettingsState(),
      );
      final page = MultiBlocProvider(
        providers: [
          BlocProvider<NewChatCubit>.value(value: cubit),
          BlocProvider<HomeCubit>.value(value: homeCubit),
          BlocProvider<SettingsCubit>.value(value: settingsCubit),
        ],
        child: const MaterialApp(
          home: NewChatView(),
        ),
      );
      await tester.pumpWidget(page);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byType(IconButton), findsNWidgets(12));
    });

    testWidgets('Input TextField', (tester) async {
      when(() => cubit.state).thenReturn(
        const ChatCard(
          icon: Icon(
            IconData(0xe481, fontFamily: 'MaterialIcons'),
          ),
          title: '',
        ),
      );
      when(() => homeCubit.state).thenReturn(
        const ChatsState([
          ChatCard(
            icon: Icon(
              IconData(0xe481, fontFamily: 'MaterialIcons'),
            ),
            title: '',
          ),
        ], 0),
      );
      when(() => settingsCubit.state).thenReturn(
        SettingsState(),
      );
      final page = MultiBlocProvider(
        providers: [
          BlocProvider<NewChatCubit>.value(value: cubit),
          BlocProvider<HomeCubit>.value(value: homeCubit),
          BlocProvider<SettingsCubit>.value(value: settingsCubit),
        ],
        child: const MaterialApp(
          home: const NewChatView(),
        ),
      );
      await tester.pumpWidget(page);
      await tester.enterText(find.byType(TextField), 'Random text');
      expect(find.text('Random text'), findsOneWidget);
    });

    testWidgets('Tap IconButton', (tester) async {
      when(() => cubit.state).thenReturn(
        const ChatCard(
          icon: Icon(
            IconData(0xe481, fontFamily: 'MaterialIcons'),
          ),
          title: '',
        ),
      );
      when(() => homeCubit.state).thenReturn(
        const ChatsState([
          ChatCard(
            icon: Icon(
              IconData(0xe481, fontFamily: 'MaterialIcons'),
            ),
            title: '',
          ),
        ], 0),
      );
      when(() => settingsCubit.state).thenReturn(
        SettingsState(),
      );
      final page = MultiBlocProvider(
        providers: [
          BlocProvider<NewChatCubit>.value(value: cubit),
          BlocProvider<HomeCubit>.value(value: homeCubit),
          BlocProvider<SettingsCubit>.value(value: settingsCubit),
        ],
        child: const MaterialApp(
          home: const NewChatView(),
        ),
      );
      await tester.pumpWidget(page);
      await tester.tap(find.byType(IconButton).first);
      await tester.tap(find.byType(IconButton).first);
      verify(() => cubit.setIcon(any())).called(2);
    });
  });
}
