import 'package:flutter/cupertino.dart';

@immutable
class Event {
  final String message;
  final String date;

  Event({
    required this.message,
    required this.date,
  });

  Event copyWith({
    String? message,
    String? date,
  }) {
    return Event(
      message: message ?? this.message,
      date: date ?? this.date,
    );
  }

  @override
  String toString() => 'Event(message: $message, date: $date)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Event && other.message == message && other.date == date;
  }

  @override
  int get hashCode => message.hashCode ^ date.hashCode;
}
