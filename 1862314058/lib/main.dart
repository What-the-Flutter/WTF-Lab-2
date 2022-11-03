import 'package:flutter/material.dart';

import 'presentation/daily/daily_app_bar.dart';
import 'presentation/daily/daily_page.dart';
import 'presentation/explore/explore_app_bar.dart';
import 'presentation/explore/explore_page.dart';
import 'presentation/home/home_app_bar.dart';
import 'presentation/home/home_page.dart';
import 'presentation/timeline/timeline_app_bar.dart';
import 'presentation/timeline/timeline_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration:
                  BoxDecoration(color: Theme.of(context).colorScheme.primary),
              child: const ListTile(
                title: Text('October 2022'),
                subtitle: Text('(Click here to setup Drive backups)'),
              ),
            ),
            const ListTile(
              leading: Icon(Icons.card_giftcard),
              title: Text('Help spread the word'),
            ),
            const ListTile(
              leading: Icon(Icons.search),
              title: Text('Search'),
            ),
            const ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notification'),
            ),
            const ListTile(
              leading: Icon(Icons.settings),
              title: Text('Setting'),
            ),
          ],
        ),
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: _appBars[_selectionIndex],
      ),
      body: IndexedStack(
        index: _selectionIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
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
        currentIndex: _selectionIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.blueGrey,
        onTap: _onItemTapped,
      ),
    );
  }
}
