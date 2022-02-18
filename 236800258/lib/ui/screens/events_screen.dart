import 'package:flutter/material.dart';

import '../widgets/events_screen_widgets/events_screen_body.dart';

class EventsScreen extends StatefulWidget {
  final String title;

  EventsScreen({Key? key, required this.title}) : super(key: key);
  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  bool _isFavoriteShown = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isFavoriteShown = !_isFavoriteShown;
              });
            },
            icon: _isFavoriteShown
                ? const Icon(Icons.favorite)
                : const Icon(Icons.favorite_border_outlined),
          )
        ],
      ),
      body: EventsScreenBody(
        isFavoriteShown: _isFavoriteShown,
        taskName: widget.title,
      ),
    );
  }
}
