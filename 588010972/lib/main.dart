import 'package:flutter/material.dart';
import 'event_screen.dart';
import 'info_page.dart';
import 'inherited_main.dart';
import 'task.dart';
import 'task_creation_edit_screen.dart';
import 'theme/app_theme.dart';
import 'theme/custom_theme.dart';

void main() {
  runApp(CustomTheme(
    key: UniqueKey(),
    child: MyApp(),
    themeName: ThemeName.light,
  ));
}

class MyApp extends StatelessWidget {
  final List<Task> defaultTask = [
    Task.all(
      'Travel',
      'No Events. Click to create one.',
      const Icon(
        Icons.airport_shuttle,
      ),
      DateTime.now(),
    ),
    Task.all(
      'Family',
      'No Events. Click to create one.',
      const Icon(
        Icons.family_restroom_outlined,
      ),
      DateTime.now(),
    ),
    Task.all(
      'Sports',
      'No Events. Click to create one.',
      const Icon(
        Icons.sports_football_outlined,
      ),
      DateTime.now(),
    ),
  ];

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InheritedMain(
      tasks: defaultTask,
      child: MaterialApp(
        title: 'Chat Journal',
        theme: CustomTheme.of(context),
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
  bool defaultTheme = true;

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

  void _changeTheme(BuildContext buildContext, ThemeName themeName) {
    CustomTheme.instanceOf(buildContext).changeTheme(themeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Center(
          child: Text(_name),
        ),
        leading: const Icon(
          Icons.menu,
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.invert_colors),
              onPressed: () {
                if (defaultTheme == true) {
                  _changeTheme(context, ThemeName.dark);
                } else {
                  _changeTheme(context, ThemeName.light);
                }
              })
        ],
      ),
      body: _listWidgetForBody(context).elementAt(_selectedItem),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => NewTask()));
        },
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add),
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

  void _showPopupMenu(int indexItem, BuildContext buildContext) async {
    await showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(10, 350, 10, 400),
      items: [
        PopupMenuItem(
          child: GestureDetector(
            onTap: () {
              var sendingTask = InheritedMain.of(context)!.tasks[indexItem];
              showDialog(
                context: context,
                builder: (context) {
                  return InfoTask(task: sendingTask);
                },
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.info,
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Text(
                    'Info',
                  ),
                ),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 160),
                  ),
                ),
              ],
            ),
          ),
        ),
        PopupMenuItem(
          child: GestureDetector(
            onTap: () {},
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.add_alarm_outlined,
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Text(
                    'Pin/Unpin Page',
                  ),
                ),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 160),
                  ),
                ),
              ],
            ),
          ),
        ),
        PopupMenuItem(
          child: GestureDetector(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.archive,
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Text(
                    'Archive Page',
                  ),
                ),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 160),
                  ),
                ),
              ],
            ),
          ),
        ),
        PopupMenuItem(
          child: GestureDetector(
            onTap: () {
              var sendingTask = InheritedMain.of(context)!.tasks[indexItem];
              print(InheritedMain.of(context)!.tasks.length);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (buildContext) => NewTask.edit(
                    indexTask: indexItem,
                    taskEditable: sendingTask,
                  ),
                ),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.edit,
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Text(
                    'Edit Page',
                  ),
                ),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 160),
                  ),
                ),
              ],
            ),
          ),
        ),
        PopupMenuItem(
          child: GestureDetector(
            onTap: () {
              InheritedMain.of(context)!.tasks.removeAt(indexItem);
              setState(() {});
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.delete,
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Text(
                    'Delete Page',
                  ),
                ),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 160),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
      elevation: 8.0,
    );
  }

  List<Widget> _listWidgetForBody(BuildContext buildContext) {
    return [
      Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 40),
            child: ElevatedButton(
              style: Theme.of(context).elevatedButtonTheme.style,
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
                      InheritedMain.of(context)!.tasks[currentIndex].header,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    leading: InheritedMain.of(context)!
                        .tasks[currentIndex]
                        .leadingIcon,
                    subtitle: Text(
                      InheritedMain.of(context)!.tasks[currentIndex].lastEvent,
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    onTap: () {
                      var title =
                          InheritedMain.of(context)!.tasks[currentIndex].header;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventDialog(titleTask: title),
                        ),
                      );
                    },
                    onLongPress: () {
                      _showPopupMenu(currentIndex, context);
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
