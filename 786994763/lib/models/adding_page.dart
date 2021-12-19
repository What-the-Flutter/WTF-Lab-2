import 'package:flutter/material.dart';

class NewPage {
  bool isSelected = false;
  late Icon icon;

  NewPage(this.icon);

  NewPage.selected(this.icon, this.isSelected);
}
