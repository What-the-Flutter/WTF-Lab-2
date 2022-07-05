import 'package:diploma/home_page/event_holder_screen/add_eventholder_view.dart';
import 'package:diploma/home_page/event_holder_screen/eventholder_view.dart';
import 'package:diploma/statistics_page/summary_stats_view.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:diploma/main.dart' as app;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:integration_test/integration_test.dart';


void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseDatabase.instance.useDatabaseEmulator('localhost', 9000);
  FirebaseStorage.instance.useStorageEmulator('localhost', 9199);

  group('end-to-end test', () {
    testWidgets('tap on the floating action button, verify counter',
            (tester) async {
          app.main();
          await tester.pumpAndSettle();
          expect(find.text('Home'), findsOneWidget);
          expect(find.byType(EventHolderView), findsOneWidget);
          await tester.tap(find.byType(FloatingActionButton));
          await tester.pumpAndSettle();
          expect(find.byType(AddEventHolderView), findsOneWidget);
          expect(find.byType(TextField), findsOneWidget);
          expect(find.byType(FloatingActionButton), findsOneWidget);
          await tester.enterText(find.byType(TextField), 'Some text to input');
          expect(find.text('Some text to input'), findsOneWidget);
          await tester.pumpAndSettle();
          await tester.tap(find.byType(FloatingActionButton));
          await tester.pumpAndSettle();
          expect(find.byType(EventHolderView), findsOneWidget);
          // Finds the EventHolderView action button to tap on.
        });

    testWidgets('tap on the statistics button from Drawer', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      expect(find.text('Home'), findsOneWidget);
      expect(find.byType(EventHolderView), findsOneWidget);
      await tester.tap(find.byWidgetPredicate((widget) => widget is IconButton && widget.icon ==  const Icon(Icons.stacked_bar_chart)));
      await tester.pumpAndSettle();
      expect(find.text('Statistics'), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.byType(SummaryStatsView), findsOneWidget);
    });
  });
}