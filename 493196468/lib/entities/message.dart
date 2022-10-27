class Message{
  String text;
  DateTime sentTime;

  Message(this.text) : sentTime = DateTime.now();

  void edit(String text){
    this.text = text;
    sentTime = DateTime.now();
  }

  @override
  String toString() {
    return text;
  }
}