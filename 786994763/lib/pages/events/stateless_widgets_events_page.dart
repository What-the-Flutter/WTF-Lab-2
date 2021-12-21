import 'package:flutter/material.dart';

import 'add_event_route.dart';

class NoEventsWidget extends StatelessWidget {
  const NoEventsWidget({Key? key}) : super(key: key);

  static const _accentColor = Color(0xff86BB8B);
  final String _aboutRoute =
      'Add your first event to this page by entering some text in the textbox below and hitting the send button. Long tap the send button to align the event in the opposite direction. Tap on the bookmark icon on the top right corner to show the bookmarked events only.';

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Container(
            decoration: BoxDecoration(
              color: _accentColor.withOpacity(0.8),
              borderRadius: BorderRadius.circular(15),
            ),
            height: 280,
            width: 330,
            padding: const EdgeInsets.all(10),
            child: _defaultText,
          ),
        ),
      ),
    );
  }

  Widget get _defaultText {
    return Column(
      children: [
        Text(
          'This is page where you can track everything about "${EventList.title}" !',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        Padding(
          child: Text(
            '$_aboutRoute',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Color(0xff323232),
            ),
            textAlign: TextAlign.center,
          ),
          padding: const EdgeInsets.only(top: 20),
        ),
      ],
    );
  }
}
