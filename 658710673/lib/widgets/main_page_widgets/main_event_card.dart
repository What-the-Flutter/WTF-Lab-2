import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class EventCard extends StatefulWidget {
  const EventCard({Key? key}) : super(key: key);

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Card(
        color: Colors.white,
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        shadowColor: const Color(0x808541F6),
        child: ListTile(
          leading: Container(
            width: 60.0,
            height: 60.0,
            decoration: const BoxDecoration(
              color: Constants.primaryColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.attach_money, size: 35,),
          ),
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Header',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          subtitle: const Text(
            'Description text',
          ),
        ),
      ),
    );
  }
}