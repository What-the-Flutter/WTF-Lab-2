import 'package:flutter/material.dart';

void main() => runApp(const ChatJournalApp());

class ChatJournalApp extends StatelessWidget {
  const ChatJournalApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat Journal',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromRGBO(231, 233, 238, 1),
      ),
      home: const HomePage(title: 'Home'),
    );
  }
}

class EventsList extends StatefulWidget {
  const EventsList({Key? key}) : super(key: key);

  @override
  _EventsListState createState() => _EventsListState();
}

class _EventsListState extends State<EventsList> {
  final events = [
    'Travel',
    'Work',
    'Sports',
    'Family',
    'Travel',
    'Work',
    'Sports',
    'Family',
    'Travel',
    'Work',
    'Sports',
    'Family',
  ];
  final icons = [
    Icons.flight_takeoff_rounded,
    Icons.home_repair_service_rounded,
    Icons.sports_handball_rounded,
    Icons.bedroom_child_rounded,
    Icons.flight_takeoff_rounded,
    Icons.home_repair_service_rounded,
    Icons.sports_handball_rounded,
    Icons.bedroom_child_rounded,
    Icons.flight_takeoff_rounded,
    Icons.home_repair_service_rounded,
    Icons.sports_handball_rounded,
    Icons.bedroom_child_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: events.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(events[index]),
          subtitle: const Text('No events. Click to create one.'),
          leading: Builder(
            builder: (context) => Icon(icons[index]),
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(7),
          ),
        ),
        backgroundColor: const Color.fromRGBO(135, 148, 192, 1),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(
                Icons.menu_rounded,
                color: Color.fromRGBO(28, 33, 53, 1),
              ),
              onPressed: () {},
            );
          },
        ),
        title: Expanded(
            child: Center(
                child: Text(
          widget.title,
          style: const TextStyle(color: Color.fromRGBO(28, 33, 53, 1)),
        ))),
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(
                  Icons.brush_rounded,
                  color: Color.fromRGBO(28, 33, 53, 1),
                ),
                onPressed: () {},
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Center(
            child: Container(
              height: 50,
              width: 300,
              margin: const EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(216, 205, 176, 0.6),
                  border: Border.all(
                    color: const Color.fromRGBO(216, 205, 176, 0.6),
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(5))),
              child: Expanded(
                  child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.support_agent_rounded),
                  Text(' Questionnaire Bot')
                ],
              )),
            ),
          ),
          const Divider(),
          const Expanded(child: EventsList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(216, 205, 176, 0.9),
        onPressed: () {},
        child: const Icon(Icons.add_rounded),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromRGBO(135, 148, 192, 0.7),
        showUnselectedLabels: true,
        selectedItemColor: const Color.fromRGBO(231, 233, 238, 1),
        unselectedItemColor: const Color.fromRGBO(28, 33, 53, 1),
        selectedIconTheme: const IconThemeData(
          color: Color.fromRGBO(231, 233, 238, 20),
          size: 28,
        ),
        unselectedIconTheme: const IconThemeData(
          color: Color.fromRGBO(28, 33, 53, 1),
          size: 28,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_rounded,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_task_rounded,
            ),
            label: 'Daily',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.map_rounded,
            ),
            label: 'Timeline',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.navigation_rounded,
            ),
            label: 'Explore',
          ),
        ],
      ),
    );
  }
}
