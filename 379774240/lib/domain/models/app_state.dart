import 'package:equatable/equatable.dart';

class AppState extends Equatable {
  final int? id;
  final int chatEventId;

  AppState({
    this.id,
    required this.chatEventId,
  });

  @override
  List<Object?> get props => [
        id,
        chatEventId,
      ];

  AppState copyWith({
    int? id,
    int? chatEventId,
  }) {
    return AppState(
      id: id ?? this.id,
      chatEventId: chatEventId ?? this.chatEventId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'chatEventId': chatEventId,
    };
  }

  factory AppState.fromMap(Map<String, dynamic> map) {
    return AppState(
      id: map['id'] != null ? map['id'] as int : null,
      chatEventId: map['chatEventId'] as int,
    );
  }
}
