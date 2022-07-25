import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String? id;
  final String eventId;
  final String text;
  final DateTime date;

  const Message({
    this.id,
    required this.eventId,
    required this.text,
    required this.date,
  });

  @override
  List<Object?> get props => [
        id,
        eventId,
        text,
        date,
      ];

  Message copyWith({
    String? id,
    String? eventId,
    String? text,
    DateTime? date,
  }) {
    return Message(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      text: text ?? this.text,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'eventId': eventId,
      'text': text,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] as String?,
      eventId: map['eventId'] as String,
      text: map['text'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
    );
  }
}
