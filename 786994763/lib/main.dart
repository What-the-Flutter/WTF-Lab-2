import 'package:flutter/material.dart';

import 'models/page.dart';
import 'models/themes.dart';
import 'pages/creating_new_page/add_page_route.dart';
import 'pages/events/add_event_route.dart';
import 'pages/home/bottom_nav_bar.dart';
import 'pages/home/bottom_sheet.dart';
import 'pages/home/delete_bottom_sheet.dart';
import 'pages/home/page_listtile.dart';
import 'theme_widget.dart';

void main() {
  runApp(
    ThemeWidget(
      key: UniqueKey(),
      initialThemeKey: ThemeKeys.light,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeWidget.of(context),
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
  List<PageInfo> _pagesList = [];
  bool _theme = true;

  Future _addEvents(int index) async {
    await Navigator.pushNamed(
      context,
      EventList.routeName,
      arguments: _pagesList[index],
    );
    _pagesList.sort((a, b) => a.lastEditTime.compareTo(b.lastEditTime));
    _pagesList = _pagesList.reversed.toList();
    _pagesList.sort((a, b) {
      if (b.isPinned) {
        return 1;
      } else {
        return 0;
      }
    });
    setState(() {});
  }

  void _toggleSelection(int _index) async {
    _pagesList[_index].isSelected
        ? _pagesList[_index].isSelected = false
        : _pagesList[_index].isSelected = true;

    var result = await showModalBottomSheet(
      context: context,
      builder: (context) {
        return CustomBottomSheet(
          context: context,
          pagesList: _pagesList,
          index: _index,
        );
      },
    );
    if (result is ScreenArguments) {
      await showModalBottomSheet(
        context: context,
        builder: (context) {
          return DeleteConfirmationBottomSheet(
            pagesList: _pagesList,
            index: _index,
          );
        },
      );
    }
    setState(() {});
  }

  void _addNewPage() async {
    final result = await Navigator.pushNamed(
      context,
      PageInput.routeName,
      arguments: _pagesList,
    ) as List<PageInfo>;
    result.sort((a, b) => a.lastEditTime.compareTo(b.lastEditTime));
    _pagesList = result.reversed.toList();
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
      backgroundColor: Theme.of(context).primaryColor,
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
        return PageListTile(
          onTap: _addEvents,
          index: index,
          toggleSelection: _toggleSelection,
          pagesList: _pagesList,
        );
      },
    );
  }

  AppBar get _homeAppBar {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          color: Theme.of(context).primaryColor,
        ),
        onPressed: () {},
        tooltip: 'Open Menu',
      ),
      centerTitle: true,
      title: _titleHomePage,
      actions: [
        Container(
          child: IconButton(
            icon: Icon(
              Icons.dark_mode,
              size: 30,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () => _swtichTheme(
              context,
              _theme ? ThemeKeys.dark : ThemeKeys.light,
            ),
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
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  Widget get _questionaryBot {
    return Padding(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: GestureDetector(
            onTap: () {},
            child: Text(
              'Questionary Bot',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
        height: 60,
      ),
      padding: const EdgeInsets.only(
        top: 20,
        right: 36,
        left: 36,
      ),
    );
  }

  Widget get _fabAddNewPage {
    return FloatingActionButton(
      child: Icon(
        Icons.add,
        size: 36,
        color: Theme.of(context).primaryColorDark,
      ),
      backgroundColor: Theme.of(context).colorScheme.secondary,
      onPressed: _addNewPage,
    );
  }

  void _swtichTheme(BuildContext buildContext, ThemeKeys key) {
    setState(() => ThemeWidget.instanceOf(buildContext).setTheme(key));
    _theme ? _theme = false : _theme = true;
  }
}
