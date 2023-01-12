import 'package:flutter/material.dart';

class MenuBar extends StatefulWidget {
  final int selectionIndex;
  final Function(int) onItemTapped;

  MenuBar({
    required this.selectionIndex,
    required this.onItemTapped,
  });

  @override
  State<MenuBar> createState() => _MenuBarState();
}

class _MenuBarState extends State<MenuBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home, ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          label: 'Daily',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Timeline',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: 'Explore',
        ),
      ],
      currentIndex: widget.selectionIndex,
      selectedItemColor: Theme.of(context).iconTheme.color,
      unselectedItemColor: Colors.blueGrey,
      onTap: widget.onItemTapped,
    );
  }
}
