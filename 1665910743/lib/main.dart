import 'package:flutter/material.dart';

import 'ui/screens/daily.dart';
import 'ui/screens/explore.dart';
import 'ui/screens/home.dart';
import 'ui/screens/timeline.dart';
import 'ui/widgets/bottom_nav_bar.dart';
import 'ui/widgets/drawer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.lightGreen,
        ),
        home: const Home());
  }
}

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

  static const List<Widget> _widgetOptions = <Widget>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
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
