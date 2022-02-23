import 'package:flutter/material.dart';

const List<Icon> icons = [
  Icon(
    Icons.flight_takeoff,
    color: Colors.white,
  ),
  Icon(
    Icons.family_restroom,
    color: Colors.white,
  ),
  Icon(
    Icons.sports_volleyball,
    color: Colors.white,
  ),
  Icon(
    Icons.grade,
    color: Colors.white,
  ),
  Icon(
    Icons.sports_bar,
    color: Colors.white,
  ),
  Icon(
    Icons.sports_basketball,
    color: Colors.white,
  ),
  Icon(
    Icons.add,
    color: Colors.white,
  ),
  Icon(
    Icons.radar,
    color: Colors.white,
  ),
  Icon(
    Icons.sailing,
    color: Colors.white,
  ),
  Icon(
    Icons.earbuds,
    color: Colors.white,
  ),
  Icon(
    Icons.flight_takeoff,
    color: Colors.white,
  ),
  Icon(
    Icons.family_restroom,
    color: Colors.white,
  ),
  Icon(
    Icons.sports_volleyball,
    color: Colors.white,
  ),
  Icon(
    Icons.grade,
    color: Colors.white,
  ),
  Icon(
    Icons.sports_bar,
    color: Colors.white,
  ),
  Icon(
    Icons.sports_basketball,
    color: Colors.white,
  ),
  Icon(
    Icons.add,
    color: Colors.white,
  ),
  Icon(
    Icons.radar,
    color: Colors.white,
  ),
  Icon(
    Icons.sailing,
    color: Colors.white,
  ),
  Icon(
    Icons.earbuds,
    color: Colors.white,
  ),
  Icon(
    Icons.flight_takeoff,
    color: Colors.white,
  ),
  Icon(
    Icons.family_restroom,
    color: Colors.white,
  ),
  Icon(
    Icons.sports_volleyball,
    color: Colors.white,
  ),
  Icon(
    Icons.grade,
    color: Colors.white,
  ),
  Icon(
    Icons.sports_bar,
    color: Colors.white,
  ),
  Icon(
    Icons.sports_basketball,
    color: Colors.white,
  ),
  Icon(
    Icons.add,
    color: Colors.white,
  ),
  Icon(
    Icons.radar,
    color: Colors.white,
  ),
  Icon(
    Icons.sailing,
    color: Colors.white,
  ),
  Icon(
    Icons.earbuds,
    color: Colors.white,
  ),
];

class MyPage {
  DateTime timeCreated = DateTime.now();
  List<Event> events = [];
  String text;
  Icon icon;

  MyPage(this.text, this.icon);

  @override
  String toString() {
    return text;
  }
}

class Event {
  DateTime timeCreated = DateTime.now();
  String text;
  Image? image;

  Event(this.text);

  @override
  String toString() {
    return text;
  }
}
