import 'package:flutter/material.dart';

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
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFFAABB97),
          secondary: const Color(0xFFDCEDC8),
          onPrimary: const Color(0xFF000000),
          onSecondary: const Color(0xFF000000),
        ),
      ),
      home: const MainPage(title: 'Home'),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    Text(
      'Selected Daily',
      style: optionStyle,
    ),
    Text(
      'Selected Timeline',
      style: optionStyle,
    ),
    Text(
      'Selected Explore',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) => setState(() {_selectedIndex = index;});

  void _addTask() => setState(() {}); //TODO

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.dark_mode),
            tooltip: 'Show Snack bar',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Mode changed'),
                ),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: const [
            UserAccountsDrawerHeader(
              accountName: Text('Name'),
              accountEmail: Text('example@gmail.com'),
            ),
          ],
        ),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Color(0xFFAABB97),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_day),
            label: 'Daily',
            backgroundColor: Color(0xFFAABB97),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Timeline',
            backgroundColor: Color(0xFFAABB97),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.compass_calibration),
            label: 'Explore',
            backgroundColor: Color(0xFFAABB97),
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: const Color(0xFFDCEDC8),
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final List<String> _entries = <String>['Travel', 'Family', 'Sports'];
  final List<IconData> _icons = <IconData>[
    Icons.airplane_ticket,
    Icons.family_restroom,
    Icons.sports_basketball
  ];

  ListTile _tile(String title, String subtitle, IconData icon) {
    return ListTile(
      title: Text(title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
        ),
      ),
      subtitle: Text(subtitle),
      leading: Icon(
        icon,
        size: 50,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: _entries.length,
      itemBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: 70,
          child: _tile(_entries[index], 'No events', _icons[index]),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}
