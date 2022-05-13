import 'package:flutter/material.dart';

import 'message.dart';

class Category {
  final String name, emptymessge;
  final bool isEmpty;
  final IconData iconData;
  List messages = <Message>[];

  Category({
    required this.name,
    required this.emptymessge,
    required this.isEmpty,
    required this.iconData,
    required this.messages,
  });

  void addMessage(String text, DateTime date) {
    messages.add(
      Message(messageText: text, date: (date.hour + date.minute).toString()),
    );
  }
}

List categories = [
  Category(
    name: 'Travel',
    emptymessge: 'No events. Click to create one.',
    isEmpty: true,
    iconData: Icons.flight_takeoff,
    messages: [
      Message(
        messageText: 'Hello! Im Peter)',
        date: '17:31',
      ),
      Message(
        messageText: 'Some text that was sent by me',
        date: '17:31',
      ),
      Message(
        messageText: 'remember me to make a cup of coffee for Lisa',
        date: '17:32',
      ),
    ],
  ),
  Category(
    name: 'Family',
    emptymessge: 'No events. Click to create one.',
    isEmpty: true,
    iconData: Icons.chair,
    messages: [],
  ),
  Category(
    name: 'Sport',
    emptymessge: 'No events. Click to create one.',
    isEmpty: true,
    iconData: Icons.sports_football,
    messages: [],
  ),
];
