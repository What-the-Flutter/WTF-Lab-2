import 'package:flutter/material.dart';

import '../../models/event_categyory.dart';
import '../widgets/chat_screen_body.dart';
import '../widgets/home_widget.dart';

class ChatScreen extends StatefulWidget {
  final EventCategory event;

  const ChatScreen({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(
              () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Home(),
                  ),
                );
              },
            );
          },
        ),
      ),
      body: ChatScreenBody(
        eventList: widget.event.list,
      ),
    );
  }
}
