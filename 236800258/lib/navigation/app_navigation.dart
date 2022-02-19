import 'package:flutter/material.dart';

import '../ui/screens/events_screen.dart';
import '../ui/screens/main_screen.dart';
import 'route_names.dart';

class AppNavigation {
  static final routes = <String, Widget Function(BuildContext)>{
    RouteNames.mainScreen: (context) => MainScreen(),
  };

  static Route<Object> onGenerateRoute(RouteSettings settings) {
    if (settings.name == RouteNames.eventsScreen) {
      final arguments = settings.arguments;
      final groupTitle = arguments is String ? arguments : '';
      return MaterialPageRoute(
        builder: (context) => EventsScreen(title: groupTitle),
      );
    } else {
      return MaterialPageRoute(
        builder: (_) => const Text('Navigation error'),
      );
    }
  }
}
