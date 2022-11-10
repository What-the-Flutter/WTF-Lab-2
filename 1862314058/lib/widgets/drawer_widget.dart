import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const ListTile(
              title: Text('October 2022'),
              subtitle: Text('(Click here to setup Drive backups)'),
            ),
          ),
          const ListTile(
            leading: Icon(Icons.card_giftcard),
            title: Text('Help spread the word'),
          ),
          const ListTile(
            leading: Icon(Icons.search),
            title: Text('Search'),
          ),
          const ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notification'),
          ),
          const ListTile(
            leading: Icon(Icons.settings),
            title: Text('Setting'),
          ),
        ],
      ),
    );
  }
}
