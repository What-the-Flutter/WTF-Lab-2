import 'dart:ui';

import 'package:flutter/material.dart';

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
      home: const ChatJournal(title: 'Chat Journal'),
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
  void _stubMethod() {}

  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    const _acsentColor = Color(0xff86BB8B);

    const _categoryTitleStyle = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
    );

    const _categorySubtitleStyle = TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
    );

    const _categorySubtitleText = 'No Events. Click to create one.';

    const _categoryTitles = <String>['Travel', 'Family', 'Sports'];
    const _categoryIcons = [
      Icons.flight_takeoff,
      Icons.chair,
      Icons.sports_basketball
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.amber[50],
          ),
          onPressed: _stubMethod,
          tooltip: 'Open Menu',
        ),
        title: Container(
          child: RichText(
              text: TextSpan(
                  children: [
                TextSpan(text: widget.title),
                WidgetSpan(
                    child: Container(
                  child: const Text('🏡'),
                  padding: const EdgeInsets.only(left: 8),
                )),
              ],
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.amber[50]))),
          alignment: Alignment.center,
        ),
        actions: [
          Container(
            child: IconButton(
              icon: const Icon(
                Icons.dark_mode,
                size: 30,
              ),
              onPressed: _stubMethod,
            ),
            padding: const EdgeInsets.only(right: 6),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            child: Container(
              decoration: BoxDecoration(
                color: _acsentColor.withOpacity(0.85),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
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
              height: 50,
            ),
            padding: const EdgeInsets.only(top: 20, right: 36, left: 36),
          ),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              itemCount: _categoryTitles.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  selected: index == _selectedIndex,
                  selectedTileColor: _acsentColor,
                  contentPadding: const EdgeInsets.only(left: 36),
                  title: Text(
                    _categoryTitles[index],
                    style: _categoryTitleStyle,
                  ),
                  leading: CircleAvatar(
                    child: Icon(
                      _categoryIcons[index],
                      size: 28,
                    ),
                    radius: 28,
                  ),
                  subtitle: const Text(
                    _categorySubtitleText,
                    style: _categorySubtitleStyle,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      backgroundColor: Colors.blueGrey,
      bottomNavigationBar: BottomNavigationBar(
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
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          size: 36,
          color: Color(0xff49664c),
        ),
        backgroundColor: _acsentColor,
        onPressed: _stubMethod,
      ),
    );
  }
}
