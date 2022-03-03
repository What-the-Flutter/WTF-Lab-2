import 'package:flutter/material.dart';
import '../../pages/event_page.dart';

class HoveredItem extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Container bottomSheet;

  HoveredItem(
    this.title,
    this.subtitle,
    this.icon,
    this.bottomSheet, {
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HoveredItemState();
}

class _HoveredItemState extends State<HoveredItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).hintColor;
    return GestureDetector(
      onTap: (() => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventPage(title: widget.title),
              ),
            )
          }),
      onLongPress: (() => {
            showModalBottomSheet(
              context: context,
              builder: (context) => widget.bottomSheet,
            ),
          }),
      child: ListTile(
        title: Text(
          widget.title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 23,
            color: color,
          ),
        ),
        subtitle: Text(
          widget.subtitle,
          style: const TextStyle(fontSize: 18),
        ),
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: Theme.of(context).shadowColor,
          ),
          child: Icon(
            widget.icon,
            color: Colors.white,
            size: 40,
          ),
        ),
      ),
    );
  }
}
