import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../models/category.dart';
import '../../widgets/list_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBarHome(),
      body: ListViewHome(),
      bottomNavigationBar: NavBar(),
      floatingActionButton: FloatingActionButtonHome(),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }
}

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _currentIndex = 0;
  List<Widget> pages = const [
    Text('Home', style: AppFonts.navBarTextStyle),
    Text('Daily', style: AppFonts.navBarTextStyle),
    Text('Timeline', style: AppFonts.navBarTextStyle),
    Text('Explore', style: AppFonts.navBarTextStyle),
  ];

  @override
  Widget build(BuildContext context) {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        indicatorColor: AppColors.supportingColor,
        labelTextStyle: MaterialStateProperty.all(
          const TextStyle(fontSize: 12),
        ),
      ),
      child: NavigationBar(
        selectedIndex: _currentIndex,
        backgroundColor: Colors.transparent,
        animationDuration: const Duration(milliseconds: 500),
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        height: 60,
        onDestinationSelected: (newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.home, color: AppColors.primaryColor),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.note, color: AppColors.primaryColor),
            icon: Icon(Icons.note_outlined),
            label: 'Daily',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.map, color: AppColors.primaryColor),
            icon: Icon(Icons.map_outlined),
            label: 'Timeline',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.explore, color: AppColors.primaryColor),
            icon: Icon(Icons.explore_outlined),
            label: 'Explore',
          ),
        ],
      ),
    );
  }
}

class ListViewHome extends StatelessWidget {
  const ListViewHome({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) => ListItem(category: categories[index]),
    );
  }
}

class FloatingActionButtonHome extends StatefulWidget {
  const FloatingActionButtonHome({Key? key}) : super(key: key);

  @override
  State<FloatingActionButtonHome> createState() =>
      _FloatingActionButtonHomeState();
}

class _FloatingActionButtonHomeState extends State<FloatingActionButtonHome> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {},
      child: const Icon(
        Icons.add,
        size: 36,
      ),
      backgroundColor: AppColors.detailsColor,
      focusElevation: 16,
    );
  }
}

class AppBarHome extends StatelessWidget implements PreferredSizeWidget {
  const AppBarHome({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      leading: IconButton(
        onPressed: () {},
        icon: Image.asset('assets/icons/MenuIcon.png'),
      ),
      title: const Text('Home', style: AppFonts.headerTextStyle),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.invert_colors,
            color: AppColors.textColor,
            size: 30,
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
