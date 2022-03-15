import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class EventTile extends StatelessWidget {
  final String title;
  final DateTime date;
  final bool favorite;
  EventTile(
      {Key? key,
      required this.title,
      required this.date,
      required this.favorite})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _formattedDate = DateFormat.yMMMMd().format(date).toString();
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).primaryColor),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20),
          ),
          Row(
            children: [
              Text(_formattedDate),
              favorite
                  ? const Icon(
                      Icons.star,
                      size: 15,
                    )
                  : const Icon(
                      Icons.star_border,
                      size: 15,
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
