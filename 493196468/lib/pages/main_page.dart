import 'package:flutter/material.dart';

import '../entities/page_arguments.dart';
import '../themes/theme_changer.dart';
import 'chat_page.dart';
import 'create_new_chat_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final _chats = <Card>[];
  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          label: 'Daily',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'TimeLine',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: 'Explore',
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
    );
  }

  Card _chatCard({
    required Icon icon,
    required String title,
    required int index,
    String subtitle = 'No Events. Click to create one',
  }) {
    return Card(
      child: GestureDetector(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColorLight,
            child: icon,
          ),
          title: Text(title),
          subtitle: Text(subtitle),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatPage(chatTitle: title)),
            );
          },
        ),
        onTapDown: _getTapPosition,
        onLongPress: () => _showContextMenu(context, index),
      ),
    );
  }

  Offset _tapPosition = Offset.zero;
  void _getTapPosition(TapDownDetails details) {
    final referenceBox = context.findRenderObject() as RenderBox;
    setState(() {
      _tapPosition = referenceBox.globalToLocal(details.globalPosition);
    });
  }

  void _showContextMenu(BuildContext context, int index) async {
    final overlay = Overlay.of(context)?.context.findRenderObject();

    final result = await showMenu(
        shape: RoundedRectangleBorder(
          side:
              BorderSide(color: Theme.of(context).primaryColorLight, width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        context: context,
        position: RelativeRect.fromRect(
            Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 30, 30),
            Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
                overlay.paintBounds.size.height)),
        items: [
          const PopupMenuItem(
            value: 'Edit',
            child: Text('Edit'),
          ),
          const PopupMenuItem(
            value: 'Delete',
            child: Text(
              'Delete',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ]);

    switch (result) {
      case 'Edit':
        _editChat(index);
        break;
      case 'Delete':
        _deleteChat(index);
        setState(() {});
        break;
    }
  }

  void _deleteChat(int index) => _chats.removeAt(index);
  Future<void> _editChat(int index) async {
    final PageArguments arguments = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NewChatPage(),
      ),
    );
    _chats.removeAt(index);
    _chats.insert(
        index,
        _chatCard(
          icon: arguments.someMapVariable[arguments.someMapVariable.keys.first],
          title: arguments.someMapVariable.keys.first.toString(),
          index: _chats.length,
        ));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {ThemeChanger.of(context).stateWidget.changeTheme();},
            icon: const Icon(Icons.emoji_objects_outlined),
          ),
        ],
        title: const Text('Home'),
      ),
      body: ListView(children: [
        ..._chats,
      ]),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final PageArguments arguments = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewChatPage(),
            ),
          );
          _chats.add(_chatCard(
            icon:
                arguments.someMapVariable[arguments.someMapVariable.keys.first],
            title: arguments.someMapVariable.keys.first.toString(),
            index: _chats.length,
          ));
          setState(() {});
        },
      ),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }
}
