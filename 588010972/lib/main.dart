import 'package:flutter/material.dart';
import 'event_screen.dart';
import 'inherited_main.dart';
import 'task.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final List<Task> defaultTask = [
    Task.all(
      'Travel',
      'No Events. Click to create one.',
      const Icon(
        Icons.airport_shuttle,
      ),
    ),
    Task.all(
      'Family',
      'No Events. Click to create one.',
      const Icon(
        Icons.family_restroom_outlined,
      ),
    ),
    Task.all(
      'Sports',
      'No Events. Click to create one.',
      const Icon(
        Icons.sports_football_outlined,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return InheritedMain(
      tasks: defaultTask,
      child: MaterialApp(
        title: 'Chat Journal',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: const CollectionPages(),
      ),
    );
  }
}

class CollectionPages extends StatefulWidget {
  const CollectionPages({Key? key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<CollectionPages> {
  int _selectedItem = 0;
  String _name = bottomName.first;

  static const List<String> bottomName = [
    'Home',
    'Daily',
    'Timeline',
    'Explore'
  ];

  void _itemTapped(int index) {
    setState(() {
      _selectedItem = index;
      _name = bottomName[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(_name),
        ),
        leading: const Icon(
          Icons.menu,
        ),
        actions: [
          const IconButton(
            icon: Icon(Icons.invert_colors),
            onPressed: null,
          )
        ],
      ),
      body: _listWidgetForBody(context).elementAt(_selectedItem),
      floatingActionButton: const FloatingActionButton(
        onPressed: null,
        backgroundColor: Colors.amber,
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: bottomName[0],
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.assignment),
            label: bottomName[1],
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.timeline),
            label: bottomName[2],
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.explore),
            label: bottomName[3],
          ),
        ],
        currentIndex: _selectedItem,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.black38,
        onTap: _itemTapped,
        showUnselectedLabels: true,
      ),
    );
  }

  List<Widget> _listWidgetForBody(BuildContext buildContext) {
    return [
      Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 40),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.tealAccent,
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              onPressed: null,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      'images/robot.png',
                      height: 40,
                      width: 40,
                    ),
                    const Text(
                      'Questionnaire Bot',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: InheritedMain?.of(context)?.tasks.length,
              itemBuilder: (context, index) {
                Widget _buildTile(int currentIndex) {
                  return ListTile(
                    title: Text(
                        InheritedMain.of(context)!.tasks[currentIndex].header),
                    leading: InheritedMain.of(context)!
                        .tasks[currentIndex]
                        .leadingIcon,
                    subtitle: Text(InheritedMain.of(context)!
                        .tasks[currentIndex]
                        .lastEvent),
                    onTap: () {
                      var title =
                          InheritedMain.of(context)!.tasks[currentIndex].header;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  EventDialog(titleTask: title)));
                    },
                  );
                }

                return _buildTile(index);
              },
            ),
          )
        ],
      ),
      const Text(
        'Daily',
      ),
      const Text(
        'Timeline',
      ),
      const Text(
        'Explore',
      ),
    ];
  }
}
