import 'package:flutter/material.dart';

import '../../../entities/group.dart';
import '../../screens/daily_screen.dart';
import '../../screens/explore_screen.dart';
import '../../screens/home_screen.dart';
import '../../screens/timeline_screen.dart';

class MainScreenBody extends StatelessWidget {
  final Group? newGroup;
  final int pageIndex;
  const MainScreenBody({
    Key? key,
    required this.pageIndex,
    this.newGroup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var pages = <Widget>[
      HomeScreen(newGroup: newGroup),
      const DailyScreen(),
      const TimelineScreen(),
      const ExploreScreen(),
    ];
    return pages.elementAt(pageIndex);
  }
}
