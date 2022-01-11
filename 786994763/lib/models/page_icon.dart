import 'package:flutter/material.dart';

class NewPage {
  bool isSelected = false;
  late final Icon _icon;

  Icon get getIcon => _icon;

  NewPage(this._icon);

  NewPage.selected(this._icon, this.isSelected);
}
