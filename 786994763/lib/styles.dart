import 'package:flutter/material.dart';

TextStyle titlePageStyle = const TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 20,
);

const categoryTitleStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
);

const categorySubtitleStyle = TextStyle(
  fontWeight: FontWeight.w600,
  fontSize: 16,
);

const eventTimeStyle = TextStyle(
  fontWeight: FontWeight.w500,
  color: Color(0xff4c4c4c),
);

const pageInputHintStyle = TextStyle(
  fontWeight: FontWeight.bold,
  color: Colors.black,
  fontSize: 24,
  height: 3,
);

const borderStyle = OutlineInputBorder(
  borderSide: BorderSide(color: Colors.transparent),
);

TextStyle inputErrorStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 20,
  foreground: Paint()..color = Colors.white,
  background: Paint()..color = Colors.red,
);
