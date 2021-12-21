import 'dart:ui';

import 'package:flutter/material.dart';

import '../../models/page.dart';
import '../../styles.dart';
import '../creating_new_page/add_page_route.dart';
import '../events/add_event_route.dart';
import 'bottom_nav_bar.dart';

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
        '/': (context) => ChatJournal(title: 'Chat Journal'),
        EventList.routeName: (context) => EventList(),
        PageInput.routeName: (context) => PageInput(),
      },
    );
  }
}

class ChatJournal extends StatefulWidget {
  ChatJournal({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _ChatJournalState createState() => _ChatJournalState();
}

class _ChatJournalState extends State<ChatJournal> {
  final _accentColor = const Color(0xff86BB8B);
  int _selectedIndex = -1;
  List<PageInfo> _pagesList = [];

  void _addEvents(int index) async {
    await Navigator.pushNamed(context, EventList.routeName,
        arguments: _pagesList[index]);
    _pagesList.sort((a, b) => a.lastEditTime.compareTo(b.lastEditTime));
    _pagesList = _pagesList.reversed.toList();
    setState(() {});
  }

  void _toggleSelection(int index) {
    setState(() {
      if (_pagesList[index].isSelected) {
        _pagesList[index].isSelected = false;
        print('selected');
      } else {
        _pagesList[index].isSelected = true;
        print('not selected');
      }
    });
  }

  void _addNewPage() async {
    print('kekew');
    final result = await Navigator.pushNamed(
      context,
      PageInput.routeName,
      arguments: _pagesList,
    ) as List<PageInfo>;
    result.sort((a, b) => a.lastEditTime.compareTo(b.lastEditTime));
    _pagesList = result.reversed.toList();
    print(_pagesList.first.title);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_pagesList.isEmpty) {
      _pagesList.add(PageInfo(
        'Travel',
        const Icon(Icons.flight_takeoff),
        DateTime.now(),
        DateTime.now(),
      ));
      _pagesList.add(PageInfo(
        'Family',
        const Icon(Icons.chair),
        DateTime.now(),
        DateTime.now(),
      ));
      _pagesList.add(PageInfo(
        'Sports',
        const Icon(Icons.sports_basketball),
        DateTime.now(),
        DateTime.now(),
      ));
    }
    return Scaffold(
      appBar: _homeAppBar,
      body: Column(
        children: [
          _questionaryBot,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: _pageListView,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.blueGrey,
      bottomNavigationBar: const BottomNavBar(),
      floatingActionButton: _fabAddNewPage,
    );
  }

  Widget get _pageListView {
    return ListView.separated(
      separatorBuilder: (
        context,
        index,
      ) =>
          const Divider(
        thickness: 2,
      ),
      itemCount: _pagesList.length,
      itemBuilder: (
        context,
        index,
      ) {
        return ListTile(
          onTap: () {
            void setState() => _selectedIndex = index;
            _addEvents(index);
          },
          onLongPress: () => _toggleSelection(index),
          selected: index == _selectedIndex,
          selectedTileColor: Colors.green,
          contentPadding: const EdgeInsets.only(left: 26),
          trailing: _pagesList[index].eventList.isNotEmpty
              ? Container(
                  child: Text(
                    '${_pagesList[index].eventList.last.date.hour}:'
                    '${_pagesList[index].eventList.last.date.minute}',
                  ),
                  padding: const EdgeInsets.only(right: 14),
                )
              : const Text(''),
          title: Text(
            _pagesList[index].title,
            style: categoryTitleStyle,
          ),
          leading: CircleAvatar(
            child: _pagesList[index].icon,
            radius: 28,
          ),
          subtitle: _pagesList[index].eventList.isNotEmpty
              ? Text(
                  _pagesList[index].eventList.last.content,
                  style: categorySubtitleStyle,
                )
              : Text(
                  _pagesList[index].subtitle,
                  style: categorySubtitleStyle,
                ),
        );
      },
    );
  }

  AppBar get _homeAppBar {
    return AppBar(
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
    );
  }

  Widget get _titleHomePage {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: widget.title,
          ),
          WidgetSpan(
            child: Container(
              child: const Text('🏡'),
              padding: const EdgeInsets.only(left: 8),
            ),
          ),
        ],
        style: titlePageStyle,
      ),
    );
  }

  Widget get _questionaryBot {
    return Padding(
      child: Container(
        decoration: BoxDecoration(
          color: _accentColor.withOpacity(0.85),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: GestureDetector(
            onTap: () {},
            child: const Text(
              'Questionary Bot',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xff49664c),
              ),
            ),
          ),
        ),
        height: 60,
      ),
      padding: const EdgeInsets.only(top: 20, right: 36, left: 36),
    );
  }

  Widget get _fabAddNewPage {
    return FloatingActionButton(
      child: const Icon(
        Icons.add,
        size: 36,
        color: Color(0xff49664c),
      ),
      backgroundColor: _accentColor,
      onPressed: _addNewPage,
    );
  }
}
