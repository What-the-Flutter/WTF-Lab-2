import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Project',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const FirstScreen(),
      },
    );
  }
}

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
            IconButton(onPressed: () {}, icon: const Icon(Icons.star_half_sharp)),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
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
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add, color: Colors.black87),
          backgroundColor: Colors.yellow,
        ),
        body: Column(
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
                                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                  child: Text(
                                    'Quastionnaire Bot',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.black87),
                                  ))
                            ])),
                  ),
                )),
             SizedBox(
                // width: 300,
                 height: 300,
    child:
             ListView(
               //padding: EdgeInsets.all(8.0),
            //   // shrinkWrap: true,
               scrollDirection: Axis.vertical,
            //   // itemExtent: 300,
            // //   // reverse: true,
              children: <Widget>[
                const Divider(),
               ListTile(
                 onTap: () {},
                 title: const Text('Travel'),
                   subtitle: const Text('No Events. Click to create one.'),
                   leading: const Icon(Icons.card_travel),
                 ),
                const Divider(),
                 ListTile(
                   onTap: () {},
                   title: const Text('Family'),
                  subtitle: const Text('No Events. Click to create one.'),
                  leading: const Icon(Icons.family_restroom),
                ),
                const Divider(),
                 ListTile(
                   onTap: () {},
                  title: const Text('Sports'),
                  subtitle: const Text('No Events. Click to create one.'),
                  leading: const Icon(Icons.sports_basketball),
                ),
                const Divider(),
            ],
            )
            )
          ],
        ));
  }
}
