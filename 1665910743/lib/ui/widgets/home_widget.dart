import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../screens/daily.dart';
import '../screens/explore.dart';
import '../screens/home.dart';
import '../screens/timeline.dart';
import '../theme/inherited_widget.dart';
import '../theme/theme_data.dart';
import 'add_category_dialog.dart';
import 'bottom_nav_bar.dart';
import 'drawer.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(
      () {
        _selectedIndex = index;
      },
    );
  }

  final _selectedItems = [
    HomeScreen(),
    const Daily(),
    const Timeline(),
    const Explore(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const JourneyDrawer(),
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () {
              CustomTheme.of(context).theme == MyThemes.lightTheme
                  ? setState(
                      () {
                        CustomTheme.of(context).changeTheme(MyThemeKeys.dark);
                      },
                    )
                  : setState(
                      () {
                        CustomTheme.of(context).changeTheme(MyThemeKeys.light);
                      },
                    );
            },
            icon: CustomTheme.of(context).theme == MyThemes.lightTheme
                ? const Icon(Icons.mode_night)
                : const Icon(Icons.light_mode),
          ),
        ],
        centerTitle: true,
      ),
      body: _selectedItems.elementAt(_selectedIndex),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            HapticFeedback.mediumImpact();
            addTaskDialog(context);
          }),
      bottomNavigationBar: BottomNavBar(
        onTap: _onItemTapped,
        selectedIndex: _selectedIndex,
      ),
    );
  }
}
