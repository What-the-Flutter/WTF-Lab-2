import 'package:flutter/material.dart';

import '../bot/bot_page.dart';
import '../messages/messages_page.dart';
import 'add_post_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: double.infinity,
                minHeight: 50,
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const BotPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.smart_toy),
                label: const Text('Questionnaire bot'),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MessagesPage(),
                      ),
                    );
                  },
                  onLongPress: _postBottomSheet,
                  child: const ListTile(
                    leading: Icon(Icons.book),
                    title: Text(
                      'Journal',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('No events'),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.train_outlined),
                  title: Text(
                    'Travel',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('No events'),
                ),
                ListTile(
                  leading: Icon(Icons.monetization_on),
                  title: Text(
                    'Statistics',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('No events'),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPostPage(),
            ),
          );
        },
        tooltip: 'New Page',
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _postBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 280,
            child: _buildPostBottomMenu(),
          );
        });
  }

  Column _buildPostBottomMenu() {
    return Column(
      children: <Widget>[
        ListTile(
          leading: const Icon(
            Icons.info,
            color: Colors.green,
          ),
          title: const Text('Info'),
          onTap: () => print('ok'),
        ),
        ListTile(
          leading: const Icon(
            Icons.mode,
            color: Colors.lightGreen,
          ),
          title: const Text('Pin/Unpin Page'),
          onTap: () => print('ok'),
        ),
        ListTile(
          leading: const Icon(
            Icons.archive,
            color: Colors.yellow,
          ),
          title: const Text('Archive Page'),
          onTap: () => print('ok'),
        ),
        ListTile(
          leading: const Icon(
            Icons.edit,
            color: Colors.blue,
          ),
          title: const Text('Edit Page'),
          onTap: () => print('ok'),
        ),
        ListTile(
          leading: const Icon(
            Icons.delete,
            color: Colors.red,
          ),
          title: const Text('Delete Page'),
          onTap: () => print('ok'),
        ),
      ],
    );
  }

// popUp(){
//   showDialog(context: context, builder: ());
// }
}
