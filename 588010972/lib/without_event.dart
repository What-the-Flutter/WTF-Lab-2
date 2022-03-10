import 'package:flutter/material.dart';

class WithoutEvent extends StatelessWidget {
  final String nameTask;

  const WithoutEvent({Key? key, required this.nameTask}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        height: 280,
        width: 370,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.green,
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 60),
        child: Column(
          children: [
            Text(
              'This is the page where you can track everything '
              'about $nameTask!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                fontSize: 15,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Add your first event to the $nameTask by entering '
                'some text int the text box below and hitting the send '
                'button. Long tap the send button to align the event in'
                ' the opposite direction. Tap on the bookmark icon'
                ' on the top on the '
                'right corner to show how the bookmarked events only.',
                textAlign: TextAlign.center,
                style: const TextStyle(letterSpacing: 1.2, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
