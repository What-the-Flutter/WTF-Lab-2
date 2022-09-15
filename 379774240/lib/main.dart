import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'ui/screens/settings/settings_cubit.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var pref = await SharedPreferences.getInstance();
  var settings = SettingsState(
    isDarkTheme: pref.getBool('isDarkTheme') ?? defaultSettings['isDarkTheme'],
    isMessageLeftAlign: pref.getBool('isMessageLeftAlign') ??
        defaultSettings['isMessageLeftAlign'],
    isDateBubbleHiden: pref.getBool('isDateBubbleHiden') ??
        defaultSettings['isDateBubbleHiden'],
    fontSize: pref.getDouble('fontSize') ?? defaultSettings['fontSize'],
  );

  runApp(NotikApp(settings: settings));
}
