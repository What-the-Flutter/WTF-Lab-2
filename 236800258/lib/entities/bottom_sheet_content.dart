import 'package:flutter/material.dart';

class BottomSheetContent {
  final Icon icon;
  final String title;
  final void Function() onTap;

  BottomSheetContent({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}
