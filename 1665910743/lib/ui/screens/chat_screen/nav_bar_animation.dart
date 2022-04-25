import 'package:flutter/material.dart';

Animation<Offset> offsetAnimation(AnimationController controller) {
  final animation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0.0, -2.0),
  ).animate(
    CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOutCirc,
    ),
  );

  return animation;
}

Animation<double> scaleAnimation(AnimationController controller) {
  final animation = Tween<double>(
    begin: 1,
    end: 3,
  ).animate(
    CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOutCirc,
    ),
  );

  return animation;
}
