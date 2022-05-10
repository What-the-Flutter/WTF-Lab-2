import 'package:flutter/material.dart';

import 'package:diploma/homePage/nominalDataBase/shared_preferences_provider.dart';
import 'homePage/eventHolderScreen/eventholder_page.dart';
import 'homePage/theme/theme_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesProvider.init();
  final _prefsProvider = SharedPreferencesProvider();
  runApp(
      GeneralTheme(
        myTheme: MyTheme(_prefsProvider.getTheme()),
        child: const MaterialApp(
          title: "Diploma project",
          home: EventHolderPage(),
        ),
      ),
  );
}

