import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'data.dart';
import 'event_create.dart';
import 'event_screen.dart';
import 'themes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<MyPage> _pages = [];
  final List<Event> _events = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu),
        ),
        title: const Center(
          child: Text('Home'),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(
                () {
                  InheritedCustomTheme.of(context).switchTheme();
                },
              );
            },
            icon: const Icon(Icons.invert_colors),
          ),
        ],
      ),
      body: _pageList(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => EventCreate(_pages, -1),
            ),
          );
          setState(() {});
        },
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
        backgroundColor: Colors.yellow,
      ),
      bottomNavigationBar: _botomNavigator(context),
    );
  }

  Widget _botomNavigator(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_work),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.dialer_sip),
          label: 'Daily',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.timeline_outlined),
          label: 'Timeline',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: 'Explore',
        ),
      ],
      onTap: _onNavTap,
    );
  }

  Widget _pageList(BuildContext context) {
    return ListView.separated(
      itemCount: _pages.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) => ListTile(
        title: Text(_pages[index].text),
        leading: CircleAvatar(
          child: _pages[index].icon,
          backgroundColor: Colors.grey,
        ),
        subtitle: _pages[index].events.isEmpty
            ? const Text('No Events. Click to create one.')
            : Text(_pages[index].events.last.text),
        trailing: _pages[index].events.isEmpty
            ? const Text('')
            : Text(
                DateFormat()
                    .add_jm()
                    .format(_pages[index].events.last.timeCreated)
                    .toString(),
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF616161),
                ),
              ),
        onLongPress: () {
          modalBottomActions(context, index);
        },
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => EventScreen(_pages[index]),
            ),
          );
          setState(() {});
        },
      ),
    );
  }

  Future<dynamic> modalBottomActions(BuildContext context, int index) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        margin: const EdgeInsets.all(4.0),
        padding: const EdgeInsets.all(5.0),
        alignment: Alignment.centerLeft,
        height: 300,
        child: Column(
          children: [
            ListTile(
              onTap: () => infoDialog(context, index),
              leading: const Icon(
                Icons.info,
                color: Colors.green,
              ),
              title: const Text('Info'),
            ),
            ListTile(
              onTap: () => {},
              leading: const Icon(
                Icons.remember_me,
                color: Colors.green,
              ),
              title: const Text('Pin/Unpin Page'),
            ),
            const ListTile(
              leading: Icon(
                Icons.archive,
                color: Colors.yellow,
              ),
              title: Text('Archive Page'),
            ),
            ListTile(
              leading: const Icon(
                Icons.edit,
                color: Colors.blue,
              ),
              title: const Text('Edit Page'),
              onTap: () {
                setState(
                  () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) => EventCreate(_pages, index),
                      ),
                    );
                  },
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              title: const Text('Delete Page'),
              onTap: () {
                Navigator.pop(context);
                modalBottomDeleteSheet(context, index);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> modalBottomDeleteSheet(BuildContext context, int index) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.centerLeft,
        height: 190,
        child: Column(
          children: [
            const Text(
              'Delete Page?\n',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const Text(
              'Are you sure you want to delete this page?',
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              'Entries of this page will still be accessable'
              'in the timeline\n',
              style: TextStyle(fontSize: 16),
            ),
            deleteOrCancel(index, context),
          ],
        ),
      ),
    );
  }

  Expanded deleteOrCancel(int index, BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 150,
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              color: Colors.red,
              iconSize: 30,
              onPressed: () {
                setState(() {
                  _pages.removeAt(index);
                });
                Navigator.pop(context);
              },
              icon: const Icon(Icons.delete),
            ),
          ),
          Container(
            width: 150,
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              iconSize: 30,
              color: Colors.blue,
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.cancel),
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> infoDialog(BuildContext context, int index) {
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: CircleAvatar(
            child: _pages[index].icon,
            backgroundColor: Colors.grey,
          ),
          title: Text(_pages[index].text),
        ),
        content: SizedBox(
          height: 150,
          child: Expanded(
            child: Column(
              children: [
                ListTile(
                  title: const Text('Created'),
                  subtitle: Text(
                    DateFormat()
                        .add_jms()
                        .format(_pages[index].timeCreated)
                        .toString(),
                  ),
                ),
                ListTile(
                  title: const Text('Latest Event'),
                  subtitle: _pages[index].events.isNotEmpty
                      ? Text(
                          DateFormat()
                              .add_jms()
                              .format(_pages[index].events.last.timeCreated)
                              .toString(),
                        )
                      : const Text('No events at the time'),
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _onNavTap(index) => setState(() => _currentIndex = index);
}
