import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  final void Function(int)? onTap;
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
    return CurvedNavigationBar(
      animationDuration: const Duration(milliseconds: 300),
      color: Theme.of(context).primaryColor,
      backgroundColor: Colors.transparent,
      buttonBackgroundColor: Theme.of(context).primaryColor,
      height: 60,
      items: const [
        Icon(Icons.book),
        Icon(Icons.assignment),
        Icon(Icons.map),
        Icon(Icons.explore),
      ],
      onTap: widget.onTap,
    );
  }
}
