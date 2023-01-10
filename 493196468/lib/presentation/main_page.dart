import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive/rive.dart';
import 'package:share_plus/share_plus.dart';

import 'pages/home_page/home_view.dart';
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

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    return DarkTransition(
        isDark: theme.brightness == Brightness.dark ? true : false,
        offset: Offset(mediaQuery.size.width - 20, 80),
        duration: const Duration(milliseconds: 800),
        childBuilder: (context, index) {
          return Scaffold(
            drawer: Drawer(
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
            ),
            bottomNavigationBar: NavigationBar(
              destinations: [
                const NavigationDestination(
                  icon: Icon(
                    Icons.book_outlined,
                    color: Colors.white,
                  ),
                  label: 'Home',
                ),
                const NavigationDestination(
                  icon: Icon(
                    Icons.map_outlined,
                    color: Colors.white,
                  ),
                  label: 'TimeLine',
                ),
              ],
              onDestinationSelected: (index) {
                setState(() {
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
        });
  }
}
