import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final int? id;
  final int eventId;
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
    int? id,
    int? eventId,
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
      id: map['id'] != null ? map['id'] as int : null,
      eventId: map['eventId'] as int,
      text: map['text'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
    );
  }
}
