import 'dart:io';

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

  final _selectedItems = const [
    HomeScreen(),
    Daily(),
    Timeline(),
    Explore(),
  ];

  final _title = const [
    HomeScreen.title,
    Daily.title,
    Timeline.title,
    Explore.title,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title.elementAt(_selectedIndex)),
        centerTitle: Platform.isIOS,
        automaticallyImplyLeading: false,
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
      ),
      body: _selectedItems.elementAt(_selectedIndex),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
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
