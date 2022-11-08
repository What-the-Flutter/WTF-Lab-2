import 'package:equatable/equatable.dart';

class Message extends Equatable {
  Message({
    required this.text,
    sentTime,
    this.isSelected = false,
    this.onEdit = false,
  }) : sentTime = sentTime ?? DateTime.now();

  final String text;
  final DateTime sentTime;
  final bool isSelected;
  final bool onEdit;

  Message copyWith({
    String? text,
    DateTime? sentTime,
    bool? isSelected,
    bool? onEdit,
  }) {
    return Message(
      text: text ?? this.text,
      sentTime: sentTime ?? this.sentTime,
      isSelected: isSelected ?? this.isSelected,
      onEdit: onEdit ?? this.onEdit,
    );
  }

  @override
  String toString() {
    return text;
  }

  @override
  List<Object?> get props => [text, sentTime, isSelected, onEdit];
}
