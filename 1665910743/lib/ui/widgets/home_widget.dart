import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/category_list_cubit.dart';
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
  final _searchController = TextEditingController();

  final List<List> _selectedItems = [
    [const HomeScreen(), 'Home'],
    [const Daily(), 'Daily'],
    [const Timeline(), 'Timeline'],
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
    if (index == 1) {
      context.read<CategoryListCubit>().fetchAllEvents();
    }
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
            leading: Hero(
              tag: 'search',
              child: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {},
              ),
            ),
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
              onChanged: (value) =>
                  context.read<CategoryListCubit>().searchControll(value),
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
            centerTitle: Platform.isIOS,
            automaticallyImplyLeading: false,
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
                        CustomTheme.of(context).theme == MyThemes.lightTheme
                            ? setState(
                                () {
                                  CustomTheme.of(context)
                                      .changeTheme(MyThemeKeys.dark);
                                },
                              )
                            : setState(
                                () {
                                  CustomTheme.of(context)
                                      .changeTheme(MyThemeKeys.light);
                                },
                              );
                      },
                      icon: Icon(
                        CustomTheme.of(context).theme == MyThemes.lightTheme
                            ? Icons.nightlight_outlined
                            : Icons.light_mode,
                      ),
                    ),
            ],
          );
  }
}
