import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.smart_toy),
            label: const Text('Questionnaire bot'),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: const <Widget>[
                ListTile(
                  leading: Icon(Icons.book),
                  title: Text(
                    'Journal',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('No events'),
                ),
                ListTile(title: Text('List 2')),
                ListTile(title: Text('List 3')),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Create',
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add),
      ),
    );
  }
}
