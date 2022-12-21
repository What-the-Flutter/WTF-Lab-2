import 'package:flutter/material.dart';

import '../../widgets/drawer_widget.dart';
import '../../widgets/menu_bar_widget.dart';
import '../daily/daily_app_bar.dart';
import '../daily/daily_page.dart';
import '../explore/explore_app_bar.dart';
import '../explore/explore_page.dart';
import '../home/home_app_bar.dart';
import '../home/home_page.dart';
import '../timeline/timeline_app_bar.dart';
import '../timeline/timeline_page.dart';

class AppPage extends StatefulWidget {
  final String title;

  const AppPage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  int _selectionIndex = 0;

  final _pages = [
    HomePage(),
    const DailyPage(),
    const TimelinePage(),
    const ExplorePage(),
  ];

  final List<Widget> _appBars = const [
    HomeAppBar(),
    DailyAppBar(),
    TimelineAppBar(),
    ExploreAppBar(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectionIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: _appBars[_selectionIndex],
      ),
      body: IndexedStack(
        index: _selectionIndex,
        children: _pages,
      ),
      bottomNavigationBar: MenuBar(
        selectionIndex: _selectionIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
