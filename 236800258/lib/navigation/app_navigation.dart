import 'package:flutter/material.dart';

import '../entities/group.dart';
import '../ui/screens/create_new_group_screen.dart';
import '../ui/screens/events_screen.dart';
import '../ui/screens/main_screen.dart';
import 'route_names.dart';

class AppNavigation {
  static final routes = <String, Widget Function(BuildContext)>{
    RouteNames.createNewGroupScreen: (context) => const CreateNewGroupScreen(),
  };

  static Route<Object> onGenerateRoute(RouteSettings settings) {
    final arguments = settings.arguments;
    switch (settings.name) {
      case RouteNames.eventsScreen:
        final groupTitle = arguments is String ? arguments : '';
        return MaterialPageRoute(
          builder: (context) => EventsScreen(title: groupTitle),
        );

      case RouteNames.mainScreen:
        final newGroup = arguments is Group ? arguments : null;
        return MaterialPageRoute(
          builder: (context) => MainScreen(
            newGroup: newGroup,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Text('Navigation error'),
        );
    }
  }
}


    // if (settings.name == RouteNames.eventsScreen) {
    //   final arguments = settings.arguments;
    //   final groupTitle = arguments is String ? arguments : '';
    //   return MaterialPageRoute(
    //     builder: (context) => EventsScreen(title: groupTitle),
    //   );
    // } else {
    //   return MaterialPageRoute(
    //     builder: (_) => const Text('Navigation error'),
    //   );
    // }