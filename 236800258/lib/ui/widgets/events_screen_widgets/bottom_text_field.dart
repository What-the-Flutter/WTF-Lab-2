import 'package:flutter/material.dart';

class BottomTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function({
    required TextEditingController controller,
    required bool isRight,
  }) addToEventList;

  const BottomTextField({
    Key? key,
    required this.controller,
    required this.addToEventList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.image_rounded),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Enter event',
                border: InputBorder.none,
              ),
            ),
          ),
          GestureDetector(
            child: const Icon(Icons.send),
            onTap: () {
              addToEventList(controller: controller, isRight: false);
            },
            onLongPress: () {
              addToEventList(controller: controller, isRight: true);
            },
          ),
        ],
      ),
    );
  }
}
