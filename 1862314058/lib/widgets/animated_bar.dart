import 'package:flutter/material.dart';

class AnimatedBar extends StatelessWidget {
  final bool isActive;

  const AnimatedBar({
    Key? key,
    required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: const EdgeInsets.only(bottom: 2),
      duration: const Duration(milliseconds: 200),
      height: 4,
      width: isActive ? 20 : 0,
      decoration: BoxDecoration(
        color: Theme.of(context).iconTheme.color,
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      ),
    );
  }
}
