import 'package:flutter/material.dart';

import 'navigation/app_navigation.dart';
import 'navigation/route_names.dart';
import 'utils/theme/theme_inherit.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AppThemeProvider(
      child: MyMaterialApp(),
    );
  }
}

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeInherit.of(context).themeData,
      routes: AppNavigation.routes,
      onGenerateRoute: AppNavigation.onGenerateRoute,
      initialRoute: RouteNames.mainScreen,
    );
  }
}