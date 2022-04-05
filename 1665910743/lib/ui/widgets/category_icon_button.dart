import 'package:flutter/material.dart';

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
