import 'dart:io';

class Event {
  Event(this.description);
  DateTime timeOfCreation = DateTime.now();
  String description;
  File? image;
  @override
  String toString() {
    return description;
  }
}
