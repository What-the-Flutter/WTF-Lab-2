import 'package:flutter/material.dart';

import '../../pages/group_page.dart';
import '../../utils/constants.dart';

class EventCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const EventCard(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.icon})
      : super(key: key);

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        shadowColor: const Color(0x808541F6),
        child: ListTile(
          leading: Container(
            width: 60.0,
            height: 60.0,
            decoration: const BoxDecoration(
                color: Constants.secondaryColor, shape: BoxShape.circle),
            child: Icon(
              widget.icon,
              size: 35,
            ),
          ),
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.title,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          subtitle: Text(
            widget.subtitle,
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GroupPage(
                          title: widget.title,
                        )));
          },
        ),
      ),
    );
  }
}
