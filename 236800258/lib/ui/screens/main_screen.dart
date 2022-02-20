import 'package:flutter/material.dart';

import '../../entities/group.dart';
import '../../utils/theme/theme_inherit.dart';
import '../widgets/main_screen_widgets/main_screen_body.dart';
import '../widgets/main_screen_widgets/main_screen_bottom_bar.dart';

class MainScreen extends StatefulWidget {
  final Group? newGroup;
  MainScreen({Key? key, this.newGroup}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onSelectedTab(int index) {
    if (_selectedIndex == index) {
      return;
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                ThemeInherit.of(context).changeTheme();
              });
            },
            icon: const Icon(Icons.invert_colors),
          ),
        ],
      ),
      body: MainScreenBody(
        pageIndex: _selectedIndex,
        newGroup: widget.newGroup,
      ),
      drawer: const Drawer(),
      bottomNavigationBar: MainScreenBottomBar(
        index: _selectedIndex,
        onItemTapped: _onSelectedTab,
      ),
    );
  }
}
