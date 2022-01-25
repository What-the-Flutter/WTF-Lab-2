import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
    );
  }

  Widget _pageList(BuildContext context) {
    return ListView(
      children: <Widget>[
        Card(
          color: Colors.lightGreen.shade100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 5.0),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 40),
            onTap: () {},
            leading: CircleAvatar(
              child: const Icon(
                Icons.contact_support,
                color: Colors.black,
              ),
              backgroundColor: Colors.lightGreen.shade100,
            ),
            title: const Text(
              'Questionnaire Bot',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Card(
          child: ListTile(
            onTap: () {},
            leading: const CircleAvatar(
              child: Icon(
                Icons.flight_takeoff,
                color: Colors.white,
              ),
              backgroundColor: Colors.grey,
            ),
            title: const Text(
              'Travel',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('No events. Click to create one.'),
          ),
        ),
        Card(
          child: ListTile(
            onTap: () {},
            leading: const CircleAvatar(
              child: Icon(
                Icons.family_restroom,
                color: Colors.white,
              ),
              backgroundColor: Colors.grey,
            ),
            title: const Text(
              'Family',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('No events. Click to create one.'),
          ),
        ),
        Card(
          child: ListTile(
            onTap: () {},
            leading: const CircleAvatar(
              child: Icon(
                Icons.sports_volleyball,
                color: Colors.white,
              ),
              backgroundColor: Colors.grey,
            ),
            title: const Text(
              'Sports',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('No events. Click to create one.'),
          ),
        ),
      ],
    );
  }
}
