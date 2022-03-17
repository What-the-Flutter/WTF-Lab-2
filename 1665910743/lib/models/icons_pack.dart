import 'package:flutter/material.dart';

const List<Icon> kMyIcons = [
  Icon(Icons.track_changes),
  Icon(Icons.monetization_on),
  Icon(Icons.sports_bar),
  Icon(Icons.sports_basketball),
  Icon(Icons.card_giftcard),
  Icon(Icons.cake_rounded),
  Icon(Icons.access_time_filled),
  Icon(Icons.add_task),
  Icon(Icons.add_business_rounded)
];

class CategoryIconButton extends StatefulWidget {
  final Icon icon;
  final double size;
  final isSelected = false;

  CategoryIconButton({
    Key? key,
    required this.icon,
    required this.size,
  }) : super(key: key);

  @override
  State<CategoryIconButton> createState() => _CategoryIconButtonState();
}

class _CategoryIconButtonState extends State<CategoryIconButton> {
  @override
  Widget build(BuildContext context) {
    return Icon(
      widget.icon.icon,
      size: widget.size,
      color: (widget.isSelected == true) ? Colors.lightGreen : Colors.black,
    );
  }
}
