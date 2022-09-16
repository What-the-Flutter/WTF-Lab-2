part of 'theme_controller_cubit.dart';

class ThemeControllerState extends Equatable {
  final AppState appState;

  const ThemeControllerState({
    required this.appState,
  });

  @override
  List<Object> get props => [
        appState,
      ];

  ThemeControllerState copyWith({
    AppState? appState,
  }) {
    return ThemeControllerState(
      appState: appState ?? this.appState,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'appState': appState.toMap(),
    };
  }

  factory ThemeControllerState.fromMap(Map<String, dynamic> map) {
    return ThemeControllerState(
      appState: AppState.fromMap(map['appState'] as Map<String, dynamic>),
    );
  }
}
