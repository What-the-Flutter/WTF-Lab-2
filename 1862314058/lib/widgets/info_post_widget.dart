import 'package:flutter/material.dart';

class InfoPost extends StatelessWidget {
  final String title;
  final IconData postIcon;

  // final DateTime postCreated;
  // final DateTime postLatestEvent;

  const InfoPost({super.key, required this.title, required this.postIcon});

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
          const ListTile(
            title: Text('Created'),
            subtitle: Text('30/11/22'),
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
