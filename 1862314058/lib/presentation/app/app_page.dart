import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/rive_utils.dart';
import '../../theme/theme_state.dart';
import '../../widgets/btm_nvg.dart';
import '../../widgets/drawer_widget.dart';
import '../constants/menu.dart';
import '../daily/daily_app_bar.dart';
import '../daily/daily_page.dart';
import '../explore/explore_app_bar.dart';
import '../explore/explore_page.dart';
import '../home/home_app_bar.dart';
import '../home/home_page.dart';
import '../timeline/timeline_app_bar.dart';
import '../timeline/timeline_page.dart';

class AppPage extends StatefulWidget {
  final String title;

  const AppPage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> with SingleTickerProviderStateMixin {
  int _selectionIndex = 0;

  final _pages = [
    HomePage(),
    const DailyPage(),
    const TimelinePage(),
    const ExplorePage(),
  ];

  final List<Widget> _appBars = const [
    HomeAppBar(),
    DailyAppBar(),
    TimelineAppBar(),
    ExploreAppBar(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectionIndex = index;
    });
  }

  Menu _selectedBottonNav = bottomNavItems.first;
  late AnimationController _animationController;
  Animation<double>? _animation;

  void updateSelectedBtmNav(Menu menu) {
    if (_selectedBottonNav != menu) {
      setState(() {
        _selectedBottonNav = menu;
      });
    }
  }

  @override
  void initState() {
    BlocProvider.of<ThemeCubit>(context).init();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 200,
      ),
    )..addListener(
        () {
          setState(() {});
        },
      );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: _appBars[_selectionIndex],
      ),
      body: IndexedStack(
        index: _selectionIndex,
        children: _pages,
      ),
      bottomNavigationBar: Transform.translate(
        offset: Offset(0, 100 * _animation!.value),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(
              left: 12,
              top: 12,
              right: 12,
              bottom: 12,
            ),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...List.generate(
                  bottomNavItems.length,
                  (index) {
                    Menu navBar = bottomNavItems[index];
                    return BtmNavItem(
                      navBar: navBar,
                      press: () {
                        RiveUtils.changeSMIBoolState(
                          navBar.rive.status!,
                        );
                        updateSelectedBtmNav(navBar);
                        _onItemTapped(index);
                      },
                      riveOnInit: (artboard) {
                        navBar.rive.status = RiveUtils.getRiveInput(
                          artboard,
                          stateMachineName: navBar.rive.stateMachineName,
                        );
                      },
                      selectedNav: _selectedBottonNav,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
