class MessageFields {
  static const values = [id, textMessage, createMessageTime];
  static const String id = '_id';
  static const String textMessage = 'textMessage';
  static const String createMessageTime = 'createMessageTime';
}

class Message {
  int? id;
  final String textMessage;
  final String createMessageTime;

  Message(
      {required this.textMessage, required this.createMessageTime, this.id});

  Map<String, dynamic> toJson() => {
        MessageFields.id: id,
        MessageFields.textMessage: textMessage,
        MessageFields.createMessageTime: createMessageTime
      };

  static Message fromJson(Map<String, dynamic> json) => Message(
      id: json[MessageFields.id] as int,
      textMessage: json[MessageFields.textMessage] as String,
      createMessageTime: json[MessageFields.createMessageTime] as String);

  Message copy({int? id, String? textMessage, String? createMessageTime}) =>
      Message(
          id: id ?? this.id,
          textMessage: textMessage ?? this.textMessage,
          createMessageTime: createMessageTime ?? this.createMessageTime);
}
