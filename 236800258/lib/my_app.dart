import 'package:flutter/material.dart';


import 'navigation/app_navigation.dart';
import 'navigation/route_names.dart';
import 'utils/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      routes: AppNavigation.routes,
      onGenerateRoute: AppNavigation.onGenerateRoute,
      initialRoute: RouteNames.mainScreen,
    );
  }
}
