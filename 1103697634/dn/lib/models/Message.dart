import 'dart:io' show File;
class Message {
  int id;
  String text;
  File? photo;

  Message(this.id, this.text);
}