import 'package:flutter/material.dart';

import '../screens/daily.dart';
import '../screens/explore.dart';
import '../screens/home.dart';
import '../screens/timeline.dart';
import 'bottom_nav_bar.dart';
import 'drawer.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const _selectedItems = <Widget>[
    HomeScreen(),
    Daily(),
    Timeline(),
    Explore()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const JourneyDrawer(),
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.mode_night))
        ],
        centerTitle: true,
      ),
      body: _selectedItems.elementAt(_selectedIndex),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
      bottomNavigationBar: BottomNavBar(
        onTap: _onItemTapped,
        selectedIndex: _selectedIndex,
      ),
    );
  }
}
