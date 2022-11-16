import 'package:flutter/material.dart';

class BotPage extends StatefulWidget {
  const BotPage({Key? key}) : super(key: key);

  @override
  State<BotPage> createState() => _BotPageState();
}

class _BotPageState extends State<BotPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Bot page'),
      ),
    );
  }
}
