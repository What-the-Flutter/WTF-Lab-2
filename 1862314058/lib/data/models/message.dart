class MessageFields {
  static const values = [
    id,
    postId,
    textMessage,
    createMessageTime,
    typeMessage,
    isSelected,
  ];
  static const String id = '_id';
  static const String postId = 'postId';
  static const String textMessage = 'textMessage';
  static const String createMessageTime = 'createMessageTime';
  static const String typeMessage = 'type';
  static const String isSelected = 'isSelected';
}

class Message {
  final int id;
  final String postId;
  final String textMessage;
  final String createMessageTime;
  final int typeMessage;
  bool isSelected;

  Message({
    required this.textMessage,
    required this.createMessageTime,
    required this.id,
    required this.postId,
    required this.typeMessage,
    this.isSelected = false,
  });

  Map<String, dynamic> toJson() => {
        MessageFields.id: id,
        MessageFields.postId: postId,
        MessageFields.textMessage: textMessage,
        MessageFields.createMessageTime: createMessageTime,
        MessageFields.typeMessage: typeMessage,
        MessageFields.isSelected: isSelected,
      };

  static Message fromJson(Map<String, dynamic> json) => Message(
        id: json[MessageFields.id] as int,
        postId: json[MessageFields.postId] as String,
        textMessage: json[MessageFields.textMessage] as String,
        createMessageTime: json[MessageFields.createMessageTime] as String,
        typeMessage: json[MessageFields.typeMessage] as int,
        isSelected: json[MessageFields.isSelected] as bool,
      );

  Message copyWith({
    int? id,
    String? postId,
    String? textMessage,
    String? createMessageTime,
    int? typeMessage,
    bool? isSelected,
  }) =>
      Message(
        id: id ?? this.id,
        postId: postId ?? this.postId,
        textMessage: textMessage ?? this.textMessage,
        createMessageTime: createMessageTime ?? this.createMessageTime,
        typeMessage: typeMessage ?? this.typeMessage,
        isSelected: isSelected ?? this.isSelected,
      );
}
