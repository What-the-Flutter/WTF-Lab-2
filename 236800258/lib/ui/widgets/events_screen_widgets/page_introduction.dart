import 'package:flutter/material.dart';

class PageIntroduction extends StatelessWidget {
  final String taskName;

  const PageIntroduction({Key? key, required this.taskName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.inversePrimary.withAlpha(120),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'This is the page where you can track everything about "$taskName".',
            style:
                Theme.of(context).textTheme.headline5?.copyWith(fontSize: 22),
          ),
          const SizedBox(height: 10),
          Text(
            'Add your first event to "$taskName" page by entering some text in the text box below and hitting the send button. Long tap the send button to align the event in the opposite direction. Tap on the favorite icon on the top right corner to show the favorite events only.',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ],
      ),
    );
  }
}
