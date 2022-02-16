import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WTF Project',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const MyHomePage(title: 'Home'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    final style = ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 25),
        primary: Colors.teal[200],
        minimumSize: const Size(200, 40));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(fontSize: 30),
        ),
        centerTitle: true,
        actions: [
          const Icon(Icons.invert_colors),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 5.0))
        ],
      ),
      drawer: const Drawer(backgroundColor: Colors.teal),
      body: Column(
        children: [
          const Padding(padding: EdgeInsets.only(top: 40)),
          Row(
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
          ),
          const Padding(
            padding: EdgeInsets.only(top: 40.0),
          ),
          ListView(
            shrinkWrap: true,
            children: [
              Divider(
                height: 5,
                thickness: 5,
                color: Colors.grey[200],
              ),
              HoveredItem('Travel', 'No events. Click to create one.',
                  Icons.flight_takeoff),
              Divider(
                height: 5,
                thickness: 5,
                color: Colors.grey[200],
              ),
              HoveredItem(
                  'Family', 'No events. Click to create one.', Icons.chair),
              Divider(
                height: 5,
                thickness: 5,
                color: Colors.grey[200],
              ),
              HoveredItem('Sports', 'No events. Click to create one.',
                  Icons.sports_baseball),
              Divider(
                height: 5,
                thickness: 5,
                color: Colors.grey[200],
              ),
            ],
          )
        ],
      ),
      floatingActionButton: const FloatingActionButton(
        onPressed: null,
        tooltip: 'Button',
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Daily'),
            BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Timeline'),
            BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore')
          ]),
    );
  }
}

class HoveredItem extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  HoveredItem(this.title, this.subtitle, this.icon, {Key? key})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _HoveredItemState();
}

class _HoveredItemState extends State<HoveredItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final color = isHovered ? Colors.red : Colors.black;
    return Material(
        child: InkWell(
            onHover: (val) {
              setState(() {
                isHovered = val;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              color: (isHovered) ? Colors.black : Colors.white,
              child: ListTile(
                title: Text(widget.title,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 23,
                        color: color)),
                subtitle: Text(
                  widget.subtitle,
                  style: const TextStyle(fontSize: 18),
                ),
                leading: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.grey),
                  child: Icon(
                    widget.icon,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
            )));
  }
}
