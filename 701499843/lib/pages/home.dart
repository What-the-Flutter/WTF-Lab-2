import 'package:flutter/material.dart';
import '../widgets/home_page/hovered_item.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    final style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 25),
      primary: Colors.teal[200],
      minimumSize: const Size(200, 40),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(fontSize: 30),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: (() => {}),
            icon: const Icon(Icons.invert_colors),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
          ),
        ],
      ),
      drawer: const Drawer(backgroundColor: Colors.teal),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 40),
          ),
          botButton(style),
          const Padding(
            padding: EdgeInsets.only(top: 40.0),
          ),
          chatsList(),
        ],
      ),
      floatingActionButton: const FloatingActionButton(
        onPressed: null,
        tooltip: 'Button',
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: navBar(),
    );
  }
}

Row botButton(ButtonStyle style) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      ElevatedButton.icon(
        style: style,
        onPressed: () {},
        icon: const Icon(
          Icons.question_answer,
          size: 30.0,
        ),
        label: const Text('Questionnaire Bot'),
      ),
    ],
  );
}

ListView chatsList() {
  return ListView(
    shrinkWrap: true,
    children: [
      Divider(
        height: 5,
        thickness: 5,
        color: Colors.grey[200],
      ),
      HoveredItem(
        'Travel',
        'No events. Click to create one.',
        Icons.flight_takeoff,
      ),
      Divider(
        height: 5,
        thickness: 5,
        color: Colors.grey[200],
      ),
      HoveredItem(
        'Family',
        'No events. Click to create one.',
        Icons.chair,
      ),
      Divider(
        height: 5,
        thickness: 5,
        color: Colors.grey[200],
      ),
      HoveredItem(
        'Sports',
        'No events. Click to create one.',
        Icons.sports_baseball,
      ),
      Divider(
        height: 5,
        thickness: 5,
        color: Colors.grey[200],
      ),
    ],
  );
}

BottomNavigationBar navBar() {
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.task),
        label: 'Daily',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.map),
        label: 'Timeline',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.explore),
        label: 'Explore',
      )
    ],
  );
}
