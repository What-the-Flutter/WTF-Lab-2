import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../theme/theme_cubit/theme_cubit.dart';
import '../../theme/theme_data.dart';
import '../../widgets/drawer.dart';
import '../Category_Screen/add_category_dialog.dart';
import '../Category_Screen/home.dart';
import '../daily_screen/daily.dart';
import '../explore_screen/explore.dart';
import '../timeline_screen/filter.dart';
import '../timeline_screen/timeline.dart';
import 'bottom_nav_bar.dart';
import 'cubit/home_cubit.dart';

class Home extends StatefulWidget {
  final HomeCubit homeCubit;
  final ThemeCubit themeCubit;

  const Home({
    Key? key,
    required this.homeCubit,
    required this.themeCubit,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();

  int _selectedIndex = 0;

  final _selectedItems = {
    const HomeScreen(): 'Home',
    const Daily(): 'Daily',
    const Timeline(): 'Timeline',
    const Explore(): 'Explore',
  };

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const ValueKey('HomeScaffold'),
      drawer: const JourneyDrawer(),
      appBar: _appBar(context),
      body: _selectedItems.keys.elementAt(_selectedIndex),
      floatingActionButton: _floatingButton(context),
      bottomNavigationBar: BottomNavBar(
        onTap: _onItemTapped,
        selectedIndex: _selectedIndex,
      ),
    );
  }

  Widget _floatingButton(BuildContext context) {
    return _selectedIndex == 2
        ? FloatingActionButton(
            key: const ValueKey('FAB2'),
            backgroundColor: Theme.of(context).primaryColor,
            child: const Icon(Icons.filter_list_sharp),
            onPressed: () {
              HapticFeedback.mediumImpact();
              filterDialog(context);
            },
          )
        : FloatingActionButton(
            key: const ValueKey('FAB1'),
            backgroundColor: Theme.of(context).primaryColor,
            child: const Icon(Icons.add),
            onPressed: () {
              HapticFeedback.mediumImpact();
              addTaskDialog(context);
            });
  }

  void _onItemTapped(int index) {
    widget.homeCubit.exitSearch();
    setState(() => _selectedIndex = index);
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return context.watch<HomeCubit>().state.searchMode
        ? AppBar(
            automaticallyImplyLeading: false,
            title: TextField(
              decoration: const InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: 'Enter a search term',
              ),
              controller: _searchController,
              onChanged: (value) {
                widget.homeCubit.searchControll(value);
              },
            ),
            actions: [
              IconButton(
                onPressed: () => widget.homeCubit.exitSearch(),
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          )
        : AppBar(
            title: Text(_selectedItems.values.elementAt(_selectedIndex)),
            centerTitle: true,
            actions: _selectedIndex == 2
                ? [
                    Hero(
                      tag: 'search',
                      child: IconButton(
                        onPressed: (() => widget.homeCubit.enterSearchMode()),
                        icon: const Icon(Icons.search),
                      ),
                    ),
                    IconButton(
                      onPressed: () => widget.homeCubit.showBookmaked(),
                      icon: Icon(widget.homeCubit.state.showBookmarked
                          ? Icons.bookmark
                          : Icons.bookmark_border),
                    ),
                  ]
                : [
                    IconButton(
                      onPressed: () {
                        widget.themeCubit.state == MyThemes.lightTheme
                            ? widget.themeCubit.themeChanged(MyThemeKeys.dark)
                            : widget.themeCubit.themeChanged(MyThemeKeys.light);
                      },
                      icon: Icon(
                        widget.themeCubit.state == MyThemes.lightTheme
                            ? Icons.nightlight_outlined
                            : Icons.light_mode,
                      ),
                    ),
                  ]);
  }
}
