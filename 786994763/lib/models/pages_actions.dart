import 'package:flutter/material.dart';

class PageAction {
  late final String _title;
  late final Icon _icon;

  String get getTitle => _title;
  Icon get getIcon => _icon;

  PageAction(this._title, this._icon);
}
