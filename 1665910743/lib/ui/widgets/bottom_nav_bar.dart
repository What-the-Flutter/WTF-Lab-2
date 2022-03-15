import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  final Function(int)? onTap;
  final int selectedIndex;

  const BottomNavBar({
    Key? key,
    required this.onTap,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showUnselectedLabels: true,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.book),
          label: 'Home',
          backgroundColor: Theme.of(context).primaryColor,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.assignment),
          label: 'Daily',
          backgroundColor: Theme.of(context).primaryColor,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.map),
          label: 'Timeline',
          backgroundColor: Theme.of(context).primaryColor,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.map),
          label: 'Explore',
          backgroundColor: Theme.of(context).primaryColor,
        ),
      ],
      currentIndex: widget.selectedIndex,
      onTap: widget.onTap,
    );
  }
}
