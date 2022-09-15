import 'package:equatable/equatable.dart';

class AppState extends Equatable {
  final String? selectedEventId;

  const AppState({
    this.selectedEventId,
  });

  @override
  List<Object?> get props => [
        selectedEventId,
      ];

  AppState copyWith({
    String? selectedEventId,
  }) {
    return AppState(
      selectedEventId: selectedEventId ?? this.selectedEventId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'selectedEventId': selectedEventId,
    };
  }

  factory AppState.fromMap(Map<String, dynamic> map) {
    return AppState(
      selectedEventId: map['selectedEventId'] != null
          ? map['selectedEventId'] as String
          : null,
    );
  }
}
