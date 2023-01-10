import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String? id;
  final String text;
  final String? pictureURL;
  final DateTime sentTime;
  final bool isSelected;
  final bool onEdit;
  final String? chatId;
  final int? categoryId;
  final bool isBookmarked;

  Message({
    this.id,
    required this.text,
    sentTime,
    this.pictureURL,
    this.isSelected = false,
    this.onEdit = false,
    this.chatId,
    this.categoryId,
    this.isBookmarked = false,
  })  : sentTime = sentTime ?? DateTime.now();

  Message copyWith({
    String? id,
    String? text,
    String? pictureURL,
    DateTime? sentTime,
    bool? isSelected,
    bool? onEdit,
    String? chatId,
    int? categoryId,
    bool? isBookmarked,
  }) {
    return Message(
      id: id ?? this.id,
      text: text ?? this.text,
      pictureURL: pictureURL ?? this.pictureURL,
      sentTime: sentTime ?? this.sentTime,
      isSelected: isSelected ?? this.isSelected,
      onEdit: onEdit ?? this.onEdit,
      chatId: chatId ?? this.chatId,
      categoryId: categoryId ?? this.categoryId,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['message_id'],
      text: json['text'],
      pictureURL: json['pictureURL'],
      sentTime: DateTime.parse(json['sent_time']),
      isSelected: json['is_selected'] == 0 ? false : true,
      onEdit: json['on_edit'] == 0 ? false : true,
      chatId: json['FK_chat_table'],
      categoryId: json['FK_category_table'],
      isBookmarked: json['is_bookmarked'] == 0 ? false : true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message_id': id,
      'text': text,
      'pictureURL': pictureURL,
      'sent_time': sentTime.toString(),
      'is_selected': isSelected == false ? 0 : 1,
      'on_edit': onEdit == false ? 0 : 1,
      'FK_chat_table': chatId,
      'FK_category_table': categoryId,
      'is_bookmarked': isBookmarked == false ? 0 : 1,
    };
  }

  @override
  String toString() {
    return pictureURL.toString();
  }

  @override
  List<Object?> get props => [
        id,
        text,
        sentTime,
        isSelected,
        onEdit,
        chatId,
        categoryId,
        isBookmarked
      ];
}
