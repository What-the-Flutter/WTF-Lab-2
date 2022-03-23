import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/category.dart';
import '../utils/app_theme.dart';
import '../widgets/main_page_widgets/main_bottom_bar.dart';
import 'category_page.dart';
import 'create_category_page.dart';

class ChatJournalApp extends StatefulWidget {
  const ChatJournalApp({Key? key}) : super(key: key);

  @override
  State<ChatJournalApp> createState() => _ChatJournalAppState();
}

class _ChatJournalAppState extends State<ChatJournalApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat journal',
      theme: InheritedCustomTheme.of(context).themeData,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    _categories
      ..add(Category('Journal', const Icon(Icons.book, color: Colors.white)))
      ..add(Category('Gratitude', const Icon(Icons.grade, color: Colors.white)))
      ..add(
          Category('Notes', const Icon(Icons.menu_book, color: Colors.white)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: 190,
            leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {},
            ),
            title: const Center(
              child: Text('Home'),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.invert_colors),
                onPressed: () => setState(() {
                  InheritedCustomTheme.of(context).switchTheme();
                }),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: (InheritedCustomTheme.of(context).themeData ==
                      AppTheme.lightTheme)
                  ? Image.asset(
                      'assets/images/app_bar_bg_light.jpg',
                      fit: BoxFit.fill,
                    )
                  : Image.asset(
                      'assets/images/app_bar_bg_dark.png',
                      fit: BoxFit.fill,
                    ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, index) => _categoryCard(_categories[index], index),
              childCount: _categories.length,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateCategory(_categories, -1),
            ),
          );
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const MainBottomBar(),
    );
  }

  Padding _categoryCard(Category category, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Card(
        color: InheritedCustomTheme.of(context).themeData.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: ListTile(
          leading: CircleAvatar(
            child: category.icon,
            backgroundColor: Colors.grey,
          ),
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              category.title,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          subtitle: category.events.isEmpty
              ? const Text('No events. Click to create one')
              : Text(
                  category.events.last.description,
                ),
          trailing: category.events.isEmpty
              ? const Text('')
              : Text(
                  DateFormat()
                      .add_jm()
                      .format(category.events.last.timeOfCreation)
                      .toString(),
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF616161),
                  ),
                ),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (context) =>
                    CategoryPage(title: _categories[index].title),
              ),
            );
            setState(() {});
          },
          onLongPress: () => _modalBottomActions(context, index),
        ),
      ),
    );
  }

  Future<dynamic> _modalBottomActions(BuildContext context, int index) {
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
                Icons.push_pin_outlined,
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
              onTap: () async {
                Navigator.pop(context);
                await Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => CreateCategory(_categories, index),
                  ),
                );
                setState(() {});
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
        margin: const EdgeInsets.all(16),
        alignment: Alignment.centerLeft,
        height: 190,
        child: Column(
          children: [
            const Text(
              'Delete Page?',
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
              'Entries of this page will still be accessible in the timeline',
              style: TextStyle(fontSize: 16),
            ),
            Expanded(
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
                          _categories.removeAt(index);
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
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> infoDialog(BuildContext context, int index) {
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: CircleAvatar(
            child: _categories[index].icon,
            backgroundColor: Colors.grey,
          ),
          title: Text(_categories[index].title),
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
                        .format(_categories[index].timeOfCreation)
                        .toString(),
                  ),
                ),
                ListTile(
                  title: const Text('Latest Event'),
                  subtitle: _categories[index].events.isNotEmpty
                      ? Text(
                          DateFormat()
                              .add_jms()
                              .format(
                                  _categories[index].events.last.timeOfCreation)
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
}
