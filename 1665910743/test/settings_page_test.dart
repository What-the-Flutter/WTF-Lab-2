import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import '/Users/macbook/Dev/wtflab2/WTF-Lab-2/1665910743/lib/ui/screens/settings/settings.dart';
import '/Users/macbook/Dev/wtflab2/WTF-Lab-2/1665910743/lib/ui/theme/theme_cubit/theme_cubit.dart';
import '/Users/macbook/Dev/wtflab2/WTF-Lab-2/1665910743/lib/ui/theme/theme_data.dart';


void main() {
  group('SettingsPage', () {
    testWidgets('show alert dialog', (WidgetTester tester) async {
      final changeAlignmentButton =
          find.byKey(ValueKey('ChangeAlignmentButton'));

      await tester.pumpWidget(MaterialApp(
          home: BlocProvider(
        create: (context) => ThemeCubit(MyThemes.lightTheme),
        child: Settings(),
      )));
      await tester.tap(changeAlignmentButton);
      await tester.pump();

      final titleFinder = find.byType(AlertDialog);
      expect(titleFinder, findsOneWidget);
    });

    testWidgets('Switch get value from cubit', (WidgetTester tester) async {
      final switchButton = find.byType(Switch);

      await tester.pumpWidget(MaterialApp(
          home: BlocProvider(
        create: (context) => ThemeCubit(MyThemes.darkTheme),
        child: Settings(),
      )));

      final switchWdt = tester.widget<Switch>(switchButton);
      expect(switchWdt.value, true);
    });
  });
}
