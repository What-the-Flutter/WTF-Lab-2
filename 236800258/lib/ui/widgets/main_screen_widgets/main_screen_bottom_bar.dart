import 'package:flutter/material.dart';

class MainScreenBottomBar extends StatelessWidget {
  final int index;
  final Function(int) onItemTapped;

  const MainScreenBottomBar({
    Key? key,
    required this.index,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const [
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
          label: 'Timeline',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: 'Explore',
        ),
      ],
      currentIndex: index,
      onTap: onItemTapped,
    );
  }
}
