class MessageFields {
  static const values = [
    id,
    postId,
    textMessage,
    createMessageTime,
    typeMessage,
    isSelectedMessage,
  ];
  static const String id = '_id';
  static const String postId = 'postId';
  static const String textMessage = 'textMessage';
  static const String createMessageTime = 'createMessageTime';
  static const String typeMessage = 'type';
  static const String isSelectedMessage = 'isSelectedMessage';
}

class Message {
  final int id;
  final String postId;
  final String textMessage;
  final String createMessageTime;
  final int typeMessage;
  bool isSelectedMessage;

  Message({
    required this.textMessage,
    required this.createMessageTime,
    required this.id,
    required this.postId,
    required this.typeMessage,
    this.isSelectedMessage = false,
  });

  Map<String, dynamic> toJson() => {
        MessageFields.id: id,
        MessageFields.postId: postId,
        MessageFields.textMessage: textMessage,
        MessageFields.createMessageTime: createMessageTime,
        MessageFields.typeMessage: typeMessage,
        MessageFields.isSelectedMessage: isSelectedMessage,
      };

  static Message fromJson(Map<String, dynamic> json) => Message(
        id: json[MessageFields.id] as int,
        postId: json[MessageFields.postId] as String,
        textMessage: json[MessageFields.textMessage] as String,
        createMessageTime: json[MessageFields.createMessageTime] as String,
        typeMessage: json[MessageFields.typeMessage] as int,
        isSelectedMessage: json[MessageFields.isSelectedMessage] as bool,
      );

  Message copyWith({
    int? id,
    String? postId,
    String? textMessage,
    String? createMessageTime,
    int? typeMessage,
    bool? isSelectedMessage,
  }) =>
      Message(
        id: id ?? this.id,
        postId: postId ?? this.postId,
        textMessage: textMessage ?? this.textMessage,
        createMessageTime: createMessageTime ?? this.createMessageTime,
        typeMessage: typeMessage ?? this.typeMessage,
        isSelectedMessage: isSelectedMessage ?? this.isSelectedMessage,
      );
}
