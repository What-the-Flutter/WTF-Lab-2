class MessageFields {
  static const values = [
    id,
    textMessage,
    createMessageTime,
    typeMessage,
    isSelectedMessage
  ];
  static const String id = '_id';
  static const String textMessage = 'textMessage';
  static const String createMessageTime = 'createMessageTime';
  static const String typeMessage = 'type';
  static const String isSelectedMessage = 'isSelectedMessage';
}

class Message {
  final int id;
  final String textMessage;
  final String createMessageTime;
  final int typeMessage;
  bool isSelectedMessage;

  Message({
    required this.textMessage,
    required this.createMessageTime,
    required this.id,
    required this.typeMessage,
    this.isSelectedMessage = false,
  });

  Map<String, dynamic> toJson() => {
        MessageFields.id: id,
        MessageFields.textMessage: textMessage,
        MessageFields.createMessageTime: createMessageTime,
        MessageFields.typeMessage: typeMessage,
        MessageFields.isSelectedMessage: isSelectedMessage,
      };

  static Message fromJson(Map<String, dynamic> json) => Message(
        id: json[MessageFields.id] as int,
        textMessage: json[MessageFields.textMessage] as String,
        createMessageTime: json[MessageFields.createMessageTime] as String,
        typeMessage: json[MessageFields.typeMessage] as int,
        isSelectedMessage: json[MessageFields.isSelectedMessage] as bool,
      );

  Message copyWith({
    int? id,
    String? textMessage,
    String? createMessageTime,
    int? typeMessage,
    bool? isSelectedMessage,
  }) =>
      Message(
        id: id ?? this.id,
        textMessage: textMessage ?? this.textMessage,
        createMessageTime: createMessageTime ?? this.createMessageTime,
        typeMessage: typeMessage ?? this.typeMessage,
        isSelectedMessage: isSelectedMessage ?? this.isSelectedMessage,
      );
}
