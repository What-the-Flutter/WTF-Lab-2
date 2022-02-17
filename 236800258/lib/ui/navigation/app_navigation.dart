import 'package:flutter/material.dart';

import '../screens/main_screen.dart';
import '../screens/messages_screen.dart';

abstract class RouteNames {
  static const mainScreen = 'main_screen';
  static const messagesScreen = 'messages_screen';
}

class AppNavigation {
  static final routes = <String, Widget Function(BuildContext)>{
    RouteNames.mainScreen: (context) => MainScreen(),
  };

  static Route<Object> onGenerateRoute(RouteSettings settings) {
    if (settings.name == RouteNames.messagesScreen) {
      final arguments = settings.arguments;
      final taskTitle = arguments is String ? arguments : '';
      return MaterialPageRoute(
        builder: (context) => MessagesScreen(title: taskTitle),
      );
    } else {
      return MaterialPageRoute(
        builder: (_) => const Text('Navigation error'),
      );
    }
  }
}
