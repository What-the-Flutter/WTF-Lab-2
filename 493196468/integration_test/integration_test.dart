import 'package:diary/main.dart' as app;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  SharedPreferences.setMockInitialValues({'themeMode': 'dark'});
  FirebaseDatabase.instance.useDatabaseEmulator('localhost', 9000);
  FirebaseStorage.instance.useStorageEmulator('localhost', 9199);

  group(
    'Category page',
    () {
      testWidgets(
        'Create category page',
        (tester) async {
          final chatName = 'IntegrationTest';
          app.main();
          await tester.pump(const Duration(seconds: 1));
          expect(find.widgetWithText(AppBar, 'Home'), findsWidgets);
          await tester.tap(find.byType(FloatingActionButton).first);
          await tester.pumpAndSettle();
          final chatNameFormField = find.byType(TextFormField).first;
          final chatIconButton = find.byType(IconButton).at(2);
          await tester.enterText(chatNameFormField, chatName);
          await tester.pumpAndSettle();
          await tester.tap(chatIconButton);
          await tester.pumpAndSettle();
          await tester.tap(find.byType(FloatingActionButton).first);
          await tester.pump(const Duration(seconds: 4));
          final chatListView = find.byType(ListView).last;
          await tester.dragUntilVisible(
            find.widgetWithText(ListTile, chatName).first,
            chatListView,
            const Offset(0, -500),
            duration: const Duration(seconds: 1),
          );
          await tester.pump(const Duration(seconds: 2));
          final chatCard = find.widgetWithText(ListTile, chatName);
          expect(chatCard, findsNWidgets(2));
        },
      );

      testWidgets(
        'Delete category page',
        (tester) async {
          final chatName = 'IntegrationTest';
          app.main();
          await tester.pump(const Duration(seconds: 4));
          expect(find.widgetWithText(AppBar, 'Home'), findsWidgets);
          await tester.pump(const Duration(seconds: 4));
          final chatCard = find.widgetWithText(ListTile, chatName).first;
          await tester.longPress(chatCard);
          await tester.pump(const Duration(seconds: 4));
          final deleteIconButton = find.byIcon(Icons.delete).first;
          await tester.tap(deleteIconButton);
          await tester.pump(const Duration(seconds: 4));
          expect(find.widgetWithText(ListTile, chatName), findsNothing);
        },
      );
    },
  );
}
