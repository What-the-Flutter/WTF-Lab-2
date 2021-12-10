import 'package:flutter/material.dart';

class EventList extends StatefulWidget {
  static const routeName = '/events_route';

  const EventList({Key? key}) : super(key: key);

  @override
  _EventListState createState() => _EventListState();
}

void _stubMethod() {}

class _EventListState extends State<EventList> {
  static const _acsentColor = Color(0xff86BB8B);

  @override
  Widget build(BuildContext context) {
    final _title = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          _title,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.amber[50]),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          const IconButton(
            onPressed: _stubMethod,
            icon: Icon(Icons.search),
          ),
          const IconButton(
            onPressed: _stubMethod,
            icon: Icon(Icons.favorite_outline),
          ),
        ],
      ),
      body: _routeBody,
    );
  }

  Widget get _routeBody {
    return Column(
      children: <Widget>[
        const Expanded(child: Placeholder()),
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.bubble_chart),
              ),
              const Placeholder(
                fallbackWidth: 296,
                fallbackHeight: 40,
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.send),
              ),
            ],
          ),
        )
      ],
    );
  }
}
