import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'services/anon_auth.dart';
import 'ui/screens/home/init.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final _user = await AuthService().singIn();
  final prefs = await SharedPreferences.getInstance();
  final _initTheme = await prefs.getString('theme') ?? 'light';
  final _initFontSize = await prefs.getString('font') ?? 'medium';
  final _backgroundImage = await prefs.getString('image') ?? '';
  final _isChatBubblesToRight = await prefs.getBool('align') ?? false;
//method init settings
  FlutterNativeSplash.remove();
  runApp(
    BlocInit(
      user: _user!,
      initTheme: _initTheme,
      initFontSize: _initFontSize,
      isChatBubblesToRight: _isChatBubblesToRight,
      backgroundImagePath: _backgroundImage,
    ),
  );
}
