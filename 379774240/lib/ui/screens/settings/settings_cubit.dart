import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/models/app_state.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final FirebaseFirestore _instance = FirebaseFirestore.instance;

  SettingsCubit() : super(SettingsState(appState: AppState(chatEventId: '')));

  void init() async {
    var docAppState = _instance.collection('appState').doc('appState');
    var appState = await _readAppState(docAppState);

    emit(state.copyWith(appState: appState));
  }

  void swithTheme() async {
    var docAppState = _instance.collection('appState').doc('appState');
    var appState = await _readAppState(docAppState);

    var isLightTheme = appState.isLightTheme ? false : true;

    docAppState.update(appState.copyWith(isLightTheme: isLightTheme).toMap());
    emit(state.copyWith(
      appState: appState.copyWith(isLightTheme: isLightTheme),
    ));
  }

  Future<AppState> _readAppState(
      DocumentReference<Map<String, dynamic>> docAppState) async {
    var appStateSnapshot = await docAppState.snapshots().first;
    var appStateMap = appStateSnapshot.data();
    var appState = AppState.fromMap(appStateMap!);
    return appState;
  }
}
