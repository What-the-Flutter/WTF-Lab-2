import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:my_journal/initial_settings_func.dart';
import 'package:my_journal/main.dart' as app;
import 'package:my_journal/ui/screens/home/init.dart';

void main() {
  
  setUp(() {
    final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
        as IntegrationTestWidgetsFlutterBinding;

    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
  });
  group('end-to-end test', () {
    testWidgets('Find correct FAB', (tester) async {
      app.main();
      final initial = await init();

      await tester.pumpWidget(BlocsProvider(
        user: initial['user']!,
        initTheme: initial['initTheme'],
        initFontSize: initial['initFontSize'],
        isChatBubblesToRight: initial['isChatBubblesToRight'],
        backgroundImagePath: initial['backgroundImage'],
      ));
      await tester.pumpAndSettle();
      final button = find.byKey(
        const ValueKey('FAB1'),
      );
      expect(find.text('Home'), findsOneWidget);

      expect(button, findsOneWidget);
    });

    testWidgets('Drawer Open correctly', (tester) async {
      app.main();
      final initial = await init();

      await tester.pumpWidget(BlocsProvider(
        user: initial['user']!,
        initTheme: initial['initTheme'],
        initFontSize: initial['initFontSize'],
        isChatBubblesToRight: initial['isChatBubblesToRight'],
        backgroundImagePath: initial['backgroundImage'],
      ));
      await tester.pumpAndSettle();
      final button = find.byTooltip('Open navigation menu');

      await tester.tap(button);
      await tester.pumpAndSettle();

      expect(find.text('My Journal'), findsOneWidget);
    });
  });
}
