import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: ListView(
        children: [
           ListTile(
            leading: const CircleAvatar(child: Icon(Icons.book)),
            title: const Text('journal'),
            subtitle: const Text('No events'),
            onTap: (){
              
            },
          )
        ],
      ),
    );
  }
}
