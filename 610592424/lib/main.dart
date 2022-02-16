import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}
//коммент
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Diploma project",
      home: Home(),
    );
  }
}


class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

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
      body: const HomeBody(),
      floatingActionButton: const FloatingActionButton(
        onPressed: null,
        child: Icon(Icons.add, color: Colors.black),
        backgroundColor: Colors.yellow,
      ),
    );
  }
}

class HomeBody extends StatelessWidget {
  const HomeBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        ListItem(
            icon: Icon(Icons.flight_takeoff_rounded, color: Colors.white),
            tital: "Travel",
            subtitle: "No events"
        ),
        Divider(),
        ListItem(
            icon: Icon(Icons.chair, color: Colors.white),
            tital: "Family",
            subtitle: "No events"
        ),
        Divider(),
        ListItem(
            icon: Icon(Icons.fitness_center_outlined, color: Colors.white),
            tital: "Sports",
            subtitle: "No events"
        ),
      ],
    );
  }
}

class ListItem extends StatelessWidget {
  const ListItem(
      {Key? key,
        required this.icon,
        required this.tital,
        required this.subtitle})
      : super(key: key);

  final Icon icon;
  final String tital;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Stack(
        alignment: Alignment.center,
        children: [
          const CircleAvatar(backgroundColor: Colors.grey, radius: 25),
          icon
        ],
      ),
      title:  Text(tital),
      subtitle: Text (subtitle),
    );
  }
}