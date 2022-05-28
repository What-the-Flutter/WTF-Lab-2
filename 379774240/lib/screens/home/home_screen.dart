import 'package:flutter/material.dart';

import '../../inherited/app_state.dart';
import '../addCategory/add_category_screen.dart';
import 'components/body.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPage = 0;
  List<Widget> pages = const [
    Text('Home'),
    Text('Daily'),
    Text('Timeline'),
    Text('Explore'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Body(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _crateCategoryWithFetchedData(context, 'Create a new category');
        },
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
      bottomNavigationBar: buildNavBar(),
    );
  }

  NavigationBar buildNavBar() {
    return NavigationBar(
      selectedIndex: currentPage,
      animationDuration: const Duration(milliseconds: 400),
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      onDestinationSelected: (newIndex) {
        setState(() {
          currentPage = newIndex;
        });
      },
      destinations: [
        NavigationDestination(
          icon: Icon(
            Icons.home,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          selectedIcon: Icon(
            Icons.home,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.event,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          selectedIcon: Icon(
            Icons.event,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          label: 'Daily',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.timeline,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          selectedIcon: Icon(
            Icons.timeline,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          label: 'Timeline',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.explore,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          selectedIcon: Icon(
            Icons.explore,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          label: 'Explore',
        ),
      ],
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: pages[currentPage],
      leading: IconButton(
        onPressed: () {},
        icon: Icon(
          Icons.menu,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      actions: [
        IconButton(
          onPressed: switchTheme,
          icon: Icon(
            Icons.invert_colors,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ],
    );
  }

  void switchTheme() {
    final provider = StateInheritedWidget.of(context);
    provider.swichTheme();
  }

  Future<void> _crateCategoryWithFetchedData(
      BuildContext context, String title) async {
    final categories = StateInheritedWidget.of(context).state;
    final List result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddCategoryScreen(title: title)),
    );
    setState(() {
      categories.addCategory(result[0], result[1]);
    });
  }
}
