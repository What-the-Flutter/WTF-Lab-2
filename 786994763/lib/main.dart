import 'dart:ui';

import 'package:flutter/material.dart';

import 'styles.dart';
import 'subject_route.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.indigo),
      initialRoute: '/',
      routes: {
        '/': (context) => const ChatJournal(title: 'Chat Journal'),
        EventList.routeName: (context) => EventList(),
      },
    );
  }
}

class ChatJournal extends StatefulWidget {
  const ChatJournal({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _ChatJournalState createState() => _ChatJournalState();
}

class _ChatJournalState extends State<ChatJournal> {
  int _selectedIndex = -1;

  final _acsentColor = const Color(0xff86BB8B);

  final _categorySubtitleText = 'No Events. Click to create one.';

  final _categoryTitles = <String>['Travel', 'Family', 'Sports'];
  final _categoryIcons = [
    Icons.flight_takeoff,
    Icons.chair,
    Icons.sports_basketball
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.amber[50],
          ),
          onPressed: () {},
          tooltip: 'Open Menu',
        ),
        centerTitle: true,
        title: _titleHomePage,
        actions: [
          Container(
            child: IconButton(
              icon: const Icon(
                Icons.dark_mode,
                size: 30,
              ),
              onPressed: () {},
            ),
            padding: const EdgeInsets.only(right: 6),
          )
        ],
      ),
      body: Column(
        children: [
          _questionaryBot,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: _pagesListView,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.blueGrey,
      bottomNavigationBar: _bottomNavBar,
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          size: 36,
          color: Color(0xff49664c),
        ),
        backgroundColor: _acsentColor,
        onPressed: () {},
      ),
    );
  }

  Widget get _titleHomePage {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: widget.title),
          WidgetSpan(
            child: Container(
              child: const Text('🏡'),
              padding: const EdgeInsets.only(left: 8),
            ),
          ),
        ],
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.amber[50],
        ),
      ),
    );
  }

  Widget get _questionaryBot {
    return Padding(
      child: Container(
        decoration: BoxDecoration(
          color: _acsentColor.withOpacity(0.85),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: GestureDetector(
            onTap: () {},
            child: RichText(
              text: const TextSpan(
                children: [
                  WidgetSpan(
                    child: Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: Icon(
                        Icons.flutter_dash,
                        color: Color(0xff49664c),
                      ),
                    ),
                  ),
                  TextSpan(
                    text: 'Questionary Bot',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff49664c),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        height: 50,
      ),
      padding: const EdgeInsets.only(top: 20, right: 36, left: 36),
    );
  }

  Widget get _pagesListView {
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(
        thickness: 2,
      ),
      itemCount: _categoryTitles.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            void setState() => _selectedIndex = index;
            Navigator.pushNamed(context, EventList.routeName,
                arguments: _categoryTitles[index]);
          },
          selected: index == _selectedIndex,
          selectedTileColor: _acsentColor,
          contentPadding: const EdgeInsets.only(left: 36),
          title: Text(
            _categoryTitles[index],
            style: categoryTitleStyle,
          ),
          leading: CircleAvatar(
            child: Icon(
              _categoryIcons[index],
              size: 28,
            ),
            radius: 28,
          ),
          subtitle: Text(
            _categorySubtitleText,
            style: categorySubtitleStyle,
          ),
        );
      },
    );
  }

  BottomNavigationBar get _bottomNavBar {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.book,
            size: 30,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.assignment,
            size: 30,
          ),
          label: 'Daily',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.map,
            size: 30,
          ),
          label: 'Timeline',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.explore,
            size: 30,
          ),
          label: 'Explore',
          backgroundColor: Colors.green,
        ),
      ],
    );
  }
}
