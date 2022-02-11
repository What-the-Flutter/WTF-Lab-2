import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'event_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  List<String> tilesNames = ['Travel', 'Family', 'Sports'];
  List<Icon> tilesIcons = [
    const Icon(
      Icons.flight_takeoff,
      color: Colors.white,
    ),
    const Icon(
      Icons.family_restroom,
      color: Colors.white,
    ),
    const Icon(
      Icons.sports_volleyball,
      color: Colors.white,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu),
          ),
          title: const Center(
            child: Text('Home'),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.invert_colors),
            ),
          ],
        ),
        body: _pageList(context),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(
            Icons.add,
            color: Colors.black,
          ),
          backgroundColor: Colors.yellow,
        ),
        bottomNavigationBar: _botomNavigator(context));
  }

  Widget _botomNavigator(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_work),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.dialer_sip),
          label: 'Daily',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.timeline_outlined),
          label: 'Timeline',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: 'Explore',
        ),
      ],
      onTap: _onNavTap,
    );
  }

  Widget _pageList(BuildContext context) {
    return ListView.separated(
        itemCount: tilesNames.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) => ListTile(
            title: Text(tilesNames[index]),
            leading: CircleAvatar(
              child: tilesIcons[index],
              backgroundColor: Colors.grey,
            ),
            subtitle: const Text('No Events. Click to create one.'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => EventScreen(tilesNames[index]),
                ),
              );
            }));
  }

  void _onNavTap(index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
