import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'services/anon_auth.dart';

Future<Map<String, dynamic>> init() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  var settings = <String, dynamic>{};

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  settings['user'] = await AuthService().singIn();
  settings['initTheme'] = await prefs.getString('theme') ?? 'light';
  settings['initFontSize'] = await prefs.getString('font') ?? 'medium';
  settings['backgroundImage'] = await prefs.getString('image') ?? '';
  settings['isChatBubblesToRight'] = await prefs.getBool('align') ?? false;

  FlutterNativeSplash.remove();

  return settings;
}
