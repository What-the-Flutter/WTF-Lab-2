import 'package:flutter/material.dart';

class InputEventBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback addEvent;

  InputEventBar({required this.addEvent, required this.controller, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: <Expanded>[
            Expanded(
              child: TextButton(
                onPressed: () => {},
                child: Icon(
                  Icons.color_lens,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Enter event',
                ),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: addEvent,
                child: Icon(
                  Icons.send,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
