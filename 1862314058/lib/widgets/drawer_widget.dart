import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../presentation/settings/settings_page.dart';
import '../presentation/statistics/statistics_page.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final webUrlApp =
        'https://play.google.com/store/apps/details?id=com.agiletelescope.chatjournal';
    final textApp =
        'Keep track of your life with Chat Journal, a simple and elegant chat-based journal/notes application that makes journaling/note-taking fun, easy, quick and effortless.';

    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: const ListTile(
              title: Text(
                'October 2022',
              ),
              subtitle: Text(
                '(Click here to setup Drive backups)',
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.card_giftcard,
              color: Theme.of(context).iconTheme.color,
            ),
            title: const Text(
              'Help spread the word',
            ),
            onTap: () async {
              await Share.share('${textApp} ${webUrlApp}');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.search,
              color: Theme.of(context).iconTheme.color,
            ),
            title: const Text(
              'Search',
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.notifications,
              color: Theme.of(context).iconTheme.color,
            ),
            title: const Text(
              'Notification',
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.auto_graph,
              color: Theme.of(context).iconTheme.color,
            ),
            title: const Text(
              'Statistics',
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StatisticsPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Theme.of(context).iconTheme.color,
            ),
            title: const Text(
              'Settings',
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
