import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
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
          label: 'TimeLine',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: 'Explore',
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
    );
  }

  Card chatCard(
      {required Icon icon,
      required String title,
      String subtitle = 'No Events. Click to create one'}) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColorLight,
          child: icon,
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        onTap: (){},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: ListView(
        children: [
          chatCard(
              icon: const Icon(Icons.travel_explore),
              title: 'Travel',
              subtitle: 'event'),
          chatCard(
            icon: const Icon(Icons.chair_rounded),
            title: 'Family',
          ),
          chatCard(
              icon: const Icon(Icons.fitness_center),
              title: 'Sports',),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }
}
