part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  final AppState appState;

  const SettingsState({
    required this.appState,
  });

  @override
  List<Object> get props => [
        appState,
      ];

  SettingsState copyWith({
    AppState? appState,
  }) {
    return SettingsState(
      appState: appState ?? this.appState,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'appState': appState.toMap(),
    };
  }

  factory SettingsState.fromMap(Map<String, dynamic> map) {
    return SettingsState(
      appState: AppState.fromMap(map['appState'] as Map<String, dynamic>),
    );
  }
}
