import 'package:flutter/material.dart';
import '../main.dart';
import 'creating_event_group.dart';
import 'event_groups.dart';

List<String> listOfDaysOfTheWeek = <String>[
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday'
];

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  int _selectedIndex = 0;

  void sortEventGroups(List<EventGroup> currentGroupList) {
    var pinnedGroup = <EventGroup>[];
    var notPinnedGroup = <EventGroup>[];

    for (var element in currentGroupList) {
      element.isPinned ? pinnedGroup.add(element) : notPinnedGroup.add(element);
    }
    eventGroups = [...pinnedGroup, ...notPinnedGroup];
  }

  Column _scaffoldBody() {
    var isSomethingPinned = false;
    for (var item in eventGroups) {
      if (item.isPinned) {
        isSomethingPinned = true;
      }
    }
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.green[50],
          ),
          margin: const EdgeInsets.all(15),
          height: 80,
          child: SizedBox(
            width: double.maxFinite,
            child: TextButton(
              onPressed: () {},
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.help,
                      color: Colors.black87,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        'Quastionnaire Bot',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black87),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        const Divider(),
        Expanded(
          child: isSomethingPinned ? _eventGroupList() : _eventGroupList(),
        ),
      ],
    );
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  void _createInfoWindow(int index) {
    setState(() {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: ListTile(
            leading: availableIcons[eventGroups[index].iconIndex],
            title: Text(eventGroups[index].text),
          ),
          content: SizedBox(
            height: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Created'),
                      Text(
                          '${listOfDaysOfTheWeek[eventGroups[index].time.weekday]} at ${eventGroups[index].time.hour.toString()}:${eventGroups[index].time.minute.toString()}')
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [Text('Latest Event'), Text('none')],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  void _pinFunc(int index) {
    setState(() {
      Navigator.pop(context);
      eventGroups[index].isPinned = !eventGroups[index].isPinned;
      sortEventGroups(eventGroups);
    });
  }

  void _editFunc(int index) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => CreatingPage(chosenPage: index),
      ),
    );
  }

  void _deleteFunc(int index) {
    setState(() {
      eventGroups.removeAt(index);
      Navigator.pop(context);
    });
  }

  void _createBottomSheet(int index) {
    showModalBottomSheet(
      context: context,
      builder: (builder) => SizedBox(
        height: 270,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: ListTile(
                  onTap: () => _createInfoWindow(index),
                  leading: const Icon(Icons.info),
                  title: const Text('Info'),
                ),
              ),
              Expanded(
                child: ListTile(
                  onTap: () => _pinFunc(index),
                  leading: const Icon(
                    Icons.pin,
                    color: Colors.green,
                  ),
                  title: const Text('Pin/Unpin Page'),
                ),
              ),
              Expanded(
                child: ListTile(
                  onTap: () {},
                  leading: const Icon(
                    Icons.archive,
                    color: Colors.yellow,
                  ),
                  title: const Text('Archive Page'),
                ),
              ),
              Expanded(
                child: ListTile(
                  onTap: () => _editFunc(index),
                  leading: const Icon(
                    Icons.edit,
                    color: Colors.blue,
                  ),
                  title: const Text('Edit Page'),
                ),
              ),
              Expanded(
                child: ListTile(
                  onTap: () => _deleteFunc(index),
                  leading: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  title: const Text('Delete Page'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _callEventGroupScreen(int index) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => EventsList(eventGroups[index].text),
      ),
    );
  }

  ListView _eventGroupList() {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: eventGroups.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              GestureDetector(
                onLongPress: () {
                  setState(() => _createBottomSheet(index));
                },
                child: ListTile(
                    onTap: () => _callEventGroupScreen(index),
                    title: Text(eventGroups[index].text),
                    subtitle: const Text('No Events. Click to create one.'),
                    leading: availableIcons[eventGroups[index].iconIndex],
                    trailing: eventGroups[index].isPinned
                        ? const Icon(Icons.pin)
                        : null),
              ),
              const Divider(),
            ],
          );
        });
  }

  BottomNavigationBar _navigationBar() {
    return BottomNavigationBar(
      unselectedItemColor: Colors.grey,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.mark_as_unread),
          label: 'Daily',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.timeline),
          label: 'Timeline',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: 'Explore',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.teal,
      onTap: _onItemTapped,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu),
        ),
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                if (isDarkTheme) {
                  isDarkTheme = !isDarkTheme;
                  ThemeSwitcher.of(context).switchTheme(themeLight);
                } else {
                  isDarkTheme = !isDarkTheme;
                  ThemeSwitcher.of(context).switchTheme(themeDark);
                }
              },
              icon: const Icon(Icons.star_half_sharp)),
        ],
      ),
      bottomNavigationBar: _navigationBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => const CreatingPage(),
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.black87),
        backgroundColor: Colors.yellow,
      ),
      body: _scaffoldBody(),
    );
  }
}

class EventGroup {
  EventGroup(this.iconIndex, this.text) : time = DateTime.now();
  late final DateTime time;
  bool isPinned = false;
  final String text;
  final int iconIndex;
}
