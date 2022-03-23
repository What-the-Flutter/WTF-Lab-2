import 'dart:io';

class Event {
  Event(this.description, {this.attachment});

  DateTime timeOfCreation = DateTime.now();
  String description;
  File? attachment;

  @override
  String toString() {
    return description;
  }
}
