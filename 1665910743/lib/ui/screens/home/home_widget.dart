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
import '../timeline_screen/timeline.dart';
import 'bottom_nav_bar.dart';
import 'cubit/home_cubit.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  final _searchController = TextEditingController();

  final _selectedItems = {
    const HomeScreen(): 'Home',
    Daily(): 'Daily',
    Timeline(): 'Timeline',
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
      drawer: const JourneyDrawer(),
      appBar: _appBar(context),
      body: _selectedItems.keys.elementAt(_selectedIndex),
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

  void _onItemTapped(int index) {
    context.read<HomeCubit>().exitSearch();
    setState(
      () {
        _selectedIndex = index;
      },
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return context.read<HomeCubit>().state.searchMode
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
                context.read<HomeCubit>().searchControll(value);
              },
            ),
            actions: [
              IconButton(
                onPressed: () => context.read<HomeCubit>().exitSearch(),
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          )
        : AppBar(
            title: Text(_selectedItems.values.elementAt(_selectedIndex)),
            centerTitle: true,
            actions: [
              _selectedIndex == 1
                  ? Hero(
                      tag: 'search',
                      child: IconButton(
                        onPressed: (() =>
                            context.read<HomeCubit>().enterSearchMode()),
                        icon: const Icon(Icons.search),
                      ),
                    )
                  : IconButton(
                      onPressed: () {
                        context.read<ThemeCubit>().state == MyThemes.lightTheme
                            ? context
                                .read<ThemeCubit>()
                                .themeChanged(MyThemeKeys.dark)
                            : context
                                .read<ThemeCubit>()
                                .themeChanged(MyThemeKeys.light);
                      },
                      icon: Icon(
                        context.read<ThemeCubit>().state == MyThemes.lightTheme
                            ? Icons.nightlight_outlined
                            : Icons.light_mode,
                      ),
                    ),
            ],
          );
  }
}
