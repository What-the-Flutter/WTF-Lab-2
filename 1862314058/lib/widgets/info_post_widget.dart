import 'package:flutter/material.dart';

class InfoPost extends StatelessWidget {
  final String title;
  final IconData postIcon;
  final String postCreated;
  // final DateTime postLatestEvent;

  const InfoPost({super.key, required this.title, required this.postIcon, required this.postCreated});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blueGrey,
            radius: 30,
            child: Icon(
              postIcon,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: const Text('Created'),
            subtitle: Text(postCreated),
          ),
          const SizedBox(
            height: 30,
          ),
          const ListTile(
            title: Text('Latest event'),
            subtitle: Text('30/11/22'),
          ),
        ],
      ),
      actions: [
        OutlinedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('OK'),
        )
      ],
    );
  }
}
