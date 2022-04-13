import '../Entities/event_holder.dart';
import 'package:flutter/material.dart';
import 'package:diploma/Home/Entities/event.dart';

import 'events_screen.dart';

class PagesScreen extends StatelessWidget {
  PagesScreen({Key? key}) : super(key: key);

  final List<EventHolder> _eventHolders = [
    EventHolder(
        [
          Event(0, "Some text"),
          Event(1, "Some text 2")
        ],
        "Travel",
        const Icon(Icons.flight_takeoff_outlined)
    ),
    EventHolder([], "Family", const Icon(Icons.chair)),
    EventHolder([], "Sports", const Icon(Icons.fitness_center_outlined)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: const IconButton(onPressed: null, icon: Icon(Icons.menu)),
        title: const Center(
          child: Text("Home"),
        ),
        actions: const [
          IconButton(onPressed: null, icon: Icon(Icons.color_lens)),
        ],
      ),
      body: ListView(
        children: <Widget>[
          for (var element in _eventHolders)
            ListTile(
              leading: element.picture,
              title: Text(element.title),
              subtitle: Text(element.subTitle),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EventsScreen(element)),
                );
              },
            )
        ],
      ),
      floatingActionButton: const FloatingActionButton(
        onPressed: null,
        child: Icon(Icons.add, color: Colors.black),
        backgroundColor: Colors.yellow,
      ),
    );
  }
}
