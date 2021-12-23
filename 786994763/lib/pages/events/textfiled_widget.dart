import 'package:flutter/material.dart';

import '../../styles.dart';

class CustomTextField extends StatelessWidget {
  final Function onSubmitted;
  final TextEditingController controller;
  final bool validateText;
  const CustomTextField({
    Key? key,
    required this.onSubmitted,
    required this.controller,
    required this.validateText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      minLines: 1,
      onSubmitted: (var stub) {
        onSubmitted();
      },
      controller: controller,
      style: const TextStyle(
        fontSize: 20,
      ),
      decoration: InputDecoration(
        errorText: validateText ? "Event can't be empty!" : null,
        errorStyle: inputErrorStyle,
        enabledBorder: borderStyle,
        focusedBorder: borderStyle,
        hintText: 'Type your events',
        fillColor: const Color(0xffe5e5e5),
        filled: true,
      ),
    );
  }
}
