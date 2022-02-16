import 'package:flutter/material.dart';

import 'daily_screen.dart';
import 'explore_screen.dart';
import 'home_screen.dart';
import 'timeline_screen.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onSelectedTab(int index) {
    if (_selectedIndex == index) {
      return;
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.invert_colors),
          ),
        ],
      ),
      body: _MainScreenBody(pageIndex: _selectedIndex),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      drawer: const Drawer(),
      bottomNavigationBar: _MainScreenBottomBar(
        index: _selectedIndex,
        onItemTapped: _onSelectedTab,
      ),
    );
  }
}

class _MainScreenBody extends StatelessWidget {
  const _MainScreenBody({Key? key, required this.pageIndex}) : super(key: key);
  final int pageIndex;
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

class _MainScreenBottomBar extends StatelessWidget {
  const _MainScreenBottomBar({
    Key? key,
    required this.index,
    required this.onItemTapped,
  }) : super(key: key);
  final int index;
  final Function(int) onItemTapped;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          label: 'Daily',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Timeline',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: 'Explore',
        ),
      ],
      currentIndex: index,
      onTap: onItemTapped,
    );
  }
}
