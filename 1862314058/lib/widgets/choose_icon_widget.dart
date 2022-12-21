import 'package:flutter/material.dart';

import '../data/choice_icon.dart';

class ChooseIcon extends StatelessWidget {
  final ChoiceIcon choiceIcon;

  const ChooseIcon({
    super.key,
    required this.choiceIcon,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.blueGrey,
      radius: 30,
      child: Icon(
        choiceIcon.icon,
        color: Colors.white,
      ),
    );
  }
}
