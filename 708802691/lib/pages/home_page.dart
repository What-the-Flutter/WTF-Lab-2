import 'package:flutter/material.dart';
import 'events_chats.dart';

class EventsList extends StatefulWidget {
  const EventsList({Key? key}) : super(key: key);

  @override
  _EventsListState createState() => _EventsListState();
}

class _EventsListState extends State<EventsList> {
  final errorTime = '24:00';
  final List<Event> events = [
    Event(
      icon: Icons.flight_takeoff_rounded,
      title: 'Travel',
      notes: [
        Note(
          content: 'Hello World!',
          dateTime: DateTime.now(),
          rightHanded: false,
        ),
        Note(
          content: 'Please, no...!',
          dateTime: DateTime.now(),
        ),
      ],
    ),
    Event(
      icon: Icons.home_repair_service_rounded,
      title: 'Work',
      notes: [],
    ),
    Event(
      icon: Icons.sports_handball_rounded,
      title: 'Sports',
      notes: [],
    ),
    Event(
      icon: Icons.bedroom_child_rounded,
      title: 'Family',
      notes: [],
    )
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: events.length,
      itemBuilder: (context, index) => ListTile(
        hoverColor: const Color.fromRGBO(216, 205, 176, 0.4),
        title: Text(events[index].title),
        subtitle: Text(events[index].lastNote.content),
        leading: Builder(
          builder: (context) => Icon(events[index].icon),
        ),
        trailing: (events[index].lastNote.time == errorTime)
            ? const SizedBox(
                width: 1,
              )
            : Text(events[index].lastNote.time),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ChatList(
                event: events[index],
              );
            },
          ),
        ),
      ),
      separatorBuilder: (context, index) => const Divider(),
    );
  }
}

class HomeBody extends StatelessWidget {
  const HomeBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Expanded(
          child: EventsList(),
        ),
      ],
    );
  }
}

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BottomNavigationBar defaultBottomBar() {
    return BottomNavigationBar(
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
    );
  }

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
        title: Center(
          child: Text(
            widget.title,
            style: const TextStyle(
              color: Color.fromRGBO(28, 33, 53, 1),
            ),
          ),
        ),
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
      body: const HomeBody(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(216, 205, 176, 0.9),
        onPressed: () {},
        child: const Icon(Icons.add_rounded),
      ),
      bottomNavigationBar: defaultBottomBar(),
    );
  }
}
