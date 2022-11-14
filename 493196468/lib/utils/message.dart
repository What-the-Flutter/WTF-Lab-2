import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final int? id;
  final String text;
  final DateTime sentTime;
  final bool isSelected;
  final bool onEdit;
  final int? chatId;

  Message({
    this.id,
    required this.text,
    sentTime,
    this.isSelected = false,
    this.onEdit = false,
    this.chatId,
  }) : sentTime = sentTime ?? DateTime.now();

  Message copyWith({
    int? id,
    String? text,
    DateTime? sentTime,
    bool? isSelected,
    bool? onEdit,
    int? chatId,
  }) {
    return Message(
      id: id ?? this.id,
      text: text ?? this.text,
      sentTime: sentTime ?? this.sentTime,
      isSelected: isSelected ?? this.isSelected,
      onEdit: onEdit ?? this.onEdit,
      chatId: chatId ?? this.chatId,
    );
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['message_id'],
      text: json['text'],
      sentTime: DateTime.parse(json['sent_time']),
      isSelected: json['is_selected'] == 0 ? false : true,
      onEdit: json['on_edit'] == 0 ? false : true,
      chatId: json['FK_chat_table'],
    );
  }

  Map<String,dynamic> toJson(){
    return {
      'message_id': id,
      'text': text,
      'sent_time': sentTime.toString(),
      'is_selected': isSelected == false ? 0 : 1,
      'on_edit': onEdit == false ? 0 : 1,
      'FK_chat_table': chatId,
    };
  }

  @override
  String toString() {
    return onEdit.toString();
  }

  @override
  List<Object?> get props => [id, text, sentTime, isSelected, onEdit, chatId];
}
