import 'package:flutter/material.dart';

import '../entities/group.dart';
import '../ui/screens/create_new_group_screen.dart';
import '../ui/screens/events_screen.dart';
import '../ui/screens/main_screen.dart';
import 'route_names.dart';

class AppNavigation {
  static final routes = <String, Widget Function(BuildContext)>{};

  static Route<Object> onGenerateRoute(RouteSettings settings) {
    final _arguments = settings.arguments;
    switch (settings.name) {
      case RouteNames.eventsScreen:
        final _groupTitle = _arguments is String ? _arguments : '';
        return MaterialPageRoute(
          builder: (context) => EventsScreen(title: _groupTitle),
        );

      case RouteNames.mainScreen:
        final _group = _arguments is Group ? _arguments : null;
        final _newGroup =
            _group != null && _group.editingIndex == null ? _group : null;
        final _editedGroup =
            _group != null && _group.editingIndex != null ? _group : null;
        return MaterialPageRoute(
          builder: (context) => MainScreen(
            newGroup: _newGroup,
            editedGroup: _editedGroup,
          ),
        );
      case RouteNames.createNewGroupScreen:
        final _editingGroup = _arguments is Group ? _arguments : null;
        return MaterialPageRoute(
          builder: (context) => CreateNewGroupScreen(
            editingGroup: _editingGroup,
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