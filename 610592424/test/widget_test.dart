import 'package:diploma/home_page/event_holder_screen/add_eventholder_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Create eventHolder view', () {
    testWidgets('Load Widgets', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: AddEventHolderView(EventHolderViewStates.adding),
      ));
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('Input TextField', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: AddEventHolderView(EventHolderViewStates.adding),
      ));
      await tester.enterText(find.byType(TextField), 'Random text');
      expect(find.text('Random text'), findsOneWidget);
    });

    testWidgets('Icon tap', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: AddEventHolderView(EventHolderViewStates.adding),
      ));
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pump();
      expect(
          find.byWidgetPredicate((widget) =>
              widget is Container &&
              widget.decoration ==
                  const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.lightGreen,
                  )),
          findsOneWidget);
    });
  });
}
