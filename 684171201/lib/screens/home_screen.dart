import 'package:flutter/material.dart';
import 'events_screen.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  int _selectedIndex = 0;
  List<MyEventGroup> myEventGroups = [MyEventGroup(const Icon(Icons.card_travel), 'Travel'), MyEventGroup(const Icon(Icons.family_restroom), 'Family'), MyEventGroup(const Icon(Icons.sports_basketball), 'Sports')];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Column _scaffoldBody() {
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
        SizedBox(
          height: 400,
          child: _eventGroupList(),
        ),
      ],
    );
  }

  ListView _eventGroupList() {
    return ListView.builder(scrollDirection: Axis.vertical,
 itemCount: myEventGroups.length, itemBuilder: (context, index) {
return Column(children: [ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => EventsList('Travel'),
              ),
            );
          },
          title:Text(myEventGroups[index].text),
          subtitle: const Text('No Events. Click to create one.'),
          leading: myEventGroups[index].icon,
        ), const Divider()],); 
        //const Divider(),
    });
    // )(
    //   scrollDirection: Axis.vertical,
    //   children: <Widget>[
    //     const Divider(),
    //     ListTile(
    //       onTap: () {
    //         Navigator.push(
    //           context,
    //           MaterialPageRoute<void>(
    //             builder: (BuildContext context) => EventsList('Travel'),
    //           ),
    //         );
    //       },
    //       title: const Text('Travel'),
    //       subtitle: const Text('No Events. Click to create one.'),
    //       leading: const Icon(Icons.card_travel),
    //     ),
    //     const Divider(),
    //     ListTile(
    //       onTap: () {Navigator.push(
    //           context,
    //           MaterialPageRoute<void>(
    //             builder: (BuildContext context) => EventsList('Family'),
    //           ),
    //         );},
    //       title: const Text('Family'),
    //       subtitle: const Text('No Events. Click to create one.'),
    //       leading: const Icon(Icons.family_restroom),
    //     ),
    //     const Divider(),
    //     ListTile(
    //       onTap: () {Navigator.push(
    //           context,
    //           MaterialPageRoute<void>(
    //             builder: (BuildContext context) => EventsList('Sports'),
    //           ),
    //         );},
    //       title: const Text('Sports'),
    //       subtitle: const Text('No Events. Click to create one.'),
    //       leading: const Icon(Icons.sports_basketball),
    //     ),
    //     const Divider(),
    //   ],
    // );
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
          IconButton(onPressed: () {}, icon: const Icon(Icons.star_half_sharp)),
        ],
      ),
      bottomNavigationBar: _navigationBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add, color: Colors.black87),
        backgroundColor: Colors.yellow,
      ),
      body: _scaffoldBody(),
    );
  }
}

class MyEventGroup {
  MyEventGroup(this.icon, this.text);
  String text;
  Icon icon;
}
