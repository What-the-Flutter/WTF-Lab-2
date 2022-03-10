class Event {
  late String content;
  late DateTime datetime;

  bool inBookMarks = false;
  bool isEdited = false;
  bool isSelected = false;

  Event(this.content, this.datetime);
}
