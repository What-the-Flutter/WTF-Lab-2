import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive/rive.dart';
import 'package:share_plus/share_plus.dart';

import 'pages/home_page/home_view.dart';
import 'pages/statistics_page/statistics_view.dart';
import 'pages/timeline_page/timeline_view.dart';
import 'settings/cubit/settings_cubit/settings_cubit.dart';
import 'settings/settings_view.dart';
import 'settings/theme.dart';
import 'widgets/main_pages_widgets/theme_switcher.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentPageIndex = 0;

  late RiveAnimationController _btnHomeAnimationController;
  late RiveAnimationController _btnTimerAnimationController;

  @override
  void initState() {
    _btnTimerAnimationController = SimpleAnimation('active', autoplay: false);
    _btnHomeAnimationController = SimpleAnimation('active', autoplay: false);
    super.initState();
  }

  void _startBtnAnimation(RiveAnimationController controller) {
    controller.isActive = !controller.isActive;
    Future.delayed(const Duration(seconds: 1))
        .then((value) => controller.isActive = !controller.isActive);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    return DarkTransition(
      isDark: theme.brightness == Brightness.dark ? true : false,
      offset: Offset(mediaQuery.size.width - 20, 80),
      childBuilder: (context, index) {
        return Scaffold(
          drawer: const MainDrawer(),
          bottomNavigationBar: NavigationBar(
            destinations: [
              NavigationDestination(
                icon: SizedBox(
                  height: 35,
                  child: RiveAnimation.asset(
                    'assets/icons.riv',
                    artboard: 'HOME',
                    animations: ['active', 'idle'],
                    fit: BoxFit.fitHeight,
                    controllers: [_btnHomeAnimationController],
                  ),
                ),
                label: 'Home',
              ),
              NavigationDestination(
                icon: SizedBox(
                  height: 35,
                  child: RiveAnimation.asset(
                    'assets/icons.riv',
                    artboard: 'TIMER',
                    animations: ['active', 'idle'],
                    fit: BoxFit.fitHeight,
                    controllers: [_btnTimerAnimationController],
                  ),
                ),
                label: 'TimeLine',
              ),
            ],
            onDestinationSelected: (index) {
              setState(() {
                _startBtnAnimation(
                  index == 0
                      ? _btnHomeAnimationController
                      : _btnTimerAnimationController,
                );
                _currentPageIndex = index;
              });
            },
            selectedIndex: _currentPageIndex,
          ),
          body: [
            HomeView(),
            const TimelineView(),
          ][_currentPageIndex],
        );
      },
    );
  }
}

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).primaryColorLight,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Chat Diary',
              style: getHeadLineText(
                context.read<SettingsCubit>().state.textSize,
                context,
              ).copyWith(
                color: Theme.of(context).primaryColorDark,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(
              'Settings',
              style: getTitleText(
                context.read<SettingsCubit>().state.textSize,
                context,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsView(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.query_stats),
            title: Text(
              'Statistics',
              style: getTitleText(
                context.read<SettingsCubit>().state.textSize,
                context,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StatisticsView(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: Text(
              'Share',
              style: getTitleText(
                context.read<SettingsCubit>().state.textSize,
                context,
              ),
            ),
            onTap: () => Share.share(
                'https://play.google.com/store/apps/details?id=com.agiletelescope.chatjournal&hl=en&gl=US'),
          ),
        ],
      ),
    );
  }
}
