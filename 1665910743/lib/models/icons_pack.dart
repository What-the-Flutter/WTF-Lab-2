import 'package:flutter/material.dart';

List<Icon> kMyIcons = const [
  Icon(Icons.track_changes),
  Icon(Icons.monetization_on),
  Icon(Icons.sports_bar),
  Icon(Icons.sports_basketball),
  Icon(Icons.card_giftcard),
  Icon(Icons.cake_rounded),
  Icon(Icons.access_time_filled),
  Icon(Icons.add_task),
  Icon(Icons.add_business_rounded),
  Icon(Icons.account_circle),
  Icon(Icons.work_outline),
  Icon(Icons.add_circle_rounded),
  Icon(Icons.add_task_outlined),
  Icon(Icons.arrow_circle_down_sharp),
  Icon(Icons.chat),
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
    );
  }
}
