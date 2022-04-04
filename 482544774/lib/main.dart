import 'package:flutter/material.dart';

import 'ui/screens/daily.dart';
import 'ui/screens/explore.dart';
import 'ui/screens/home.dart';
import 'ui/screens/timeline.dart';
import 'ui/widgets/bottom_nav_bar.dart';

void main() {
  runApp(const Application());
}

class Application extends StatelessWidget {
  const Application({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Journal',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _selectedIndex = 0;

  static const _screens = <Widget>[
    HomeScreen(),
    DailyScreen(),
    TimelineScreen(),
    ExploreScreen(),
  ];

  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          child: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () => {},
        ),
        title: const Text('Chat Journal'),
        actions: [
          TextButton(
            child: const Icon(
              Icons.wb_sunny,
              color: Colors.white,
            ),
            onPressed: () => {},
          ),
        ],
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => {},
        tooltip: 'Add category',
      ),
      body: _screens.elementAt(_selectedIndex), 
      bottomNavigationBar: BottomNavBar(_selectedIndex, _onItemTapped),
    );
  }
}
