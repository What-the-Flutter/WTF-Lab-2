import 'package:flutter/material.dart';

import '../../screens/daily_screen.dart';
import '../../screens/explore_screen.dart';
import '../../screens/home_screen.dart';
import '../../screens/timeline_screen.dart';

class MainScreenBody extends StatelessWidget {
  final int pageIndex;
  const MainScreenBody({Key? key, required this.pageIndex}) : super(key: key);

  static const pages = <Widget>[
    HomeScreen(),
    DailyScreen(),
    TimelineScreen(),
    ExploreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return pages.elementAt(pageIndex);
  }
}
