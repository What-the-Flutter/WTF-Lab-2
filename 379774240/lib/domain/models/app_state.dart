import 'package:equatable/equatable.dart';

class AppState extends Equatable {
  final String chatEventId;
  final bool isLightTheme;

  AppState({
    required this.chatEventId,
    this.isLightTheme = false,
  });

  @override
  List<Object?> get props => [
        chatEventId,
        isLightTheme,
      ];

  AppState copyWith({
    String? chatEventId,
    bool? isLightTheme,
  }) {
    return AppState(
      chatEventId: chatEventId ?? this.chatEventId,
      isLightTheme: isLightTheme ?? this.isLightTheme,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'chatEventId': chatEventId,
      'isLightTheme': isLightTheme,
    };
  }

  factory AppState.fromMap(Map<String, dynamic> map) {
    return AppState(
      chatEventId: map['chatEventId'] as String,
      isLightTheme: map['isLightTheme'] as bool,
    );
  }
}
