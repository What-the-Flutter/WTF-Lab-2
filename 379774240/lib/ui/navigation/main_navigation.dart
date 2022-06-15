import 'package:flutter/cupertino.dart';

import '../screens/chat/chat_screen.dart';

abstract class Screens {
  static const main = '/';
  static const caht = '/chat';
  static const categoty = '/category';
}

// class MainNavigation {
//   Map<String, WidgetBuilder> get routes => <String, WidgetBuilder>{
//         Screens.main: (_) => ChatScreen(),
//       };

//   Route<dynamic>? onGenerateRoute(RouteSettings settings) {
//     return null;
//   }
// }
