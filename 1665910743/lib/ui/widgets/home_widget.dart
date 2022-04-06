import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/category_cubit/category_list_cubit.dart';
import '../../cubit/theme_cubit/theme_cubit.dart';
import '../screens/daily.dart';
import '../screens/explore.dart';
import '../screens/home.dart';
import '../screens/timeline.dart';
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
  final _searchController = TextEditingController();

  final List<List> _selectedItems = [
    [const HomeScreen(), 'Home'],
    [Daily(), 'Daily'],
    [Timeline(), 'Timeline'],
    [const Explore(), 'Explore'],
  ];

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
      body: _selectedItems.elementAt(_selectedIndex).first,
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
    
    context.read<CategoryListCubit>().exitSearch();
    setState(
      () {
        _selectedIndex = index;
      },
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return context.watch<CategoryListCubit>().state.searchMode
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
                context.read<CategoryListCubit>().searchControll(value);
              },
            ),
            actions: [
              IconButton(
                onPressed: () => context.read<CategoryListCubit>().exitSearch(),
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          )
        : AppBar(
            title: Text(_selectedItems.elementAt(_selectedIndex).last),
            centerTitle: true,
            actions: [
              _selectedIndex == 1
                  ? Hero(
                      tag: 'search',
                      child: IconButton(
                        onPressed: (() => context
                            .read<CategoryListCubit>()
                            .enterSearchMode()),
                        icon: const Icon(Icons.search),
                      ),
                    )
                  : IconButton(
                      onPressed: () {
                        setState(() {
                          context.read<ThemeCubit>().state ==
                                  MyThemes.lightTheme
                              ? context
                                  .read<ThemeCubit>()
                                  .themeChanged(MyThemeKeys.dark)
                              : context
                                  .read<ThemeCubit>()
                                  .themeChanged(MyThemeKeys.light);
                        });
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
