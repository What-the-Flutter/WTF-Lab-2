import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../domain/models/app_state.dart';
import 'themeData/dark_theme.dart';
import 'themeData/light_theme.dart';

part 'theme_controller_state.dart';

class ThemeControllerCubit extends Cubit<ThemeControllerState> {
  final FirebaseFirestore _instance = FirebaseFirestore.instance;

  ThemeControllerCubit()
      : super(ThemeControllerState(
          appState: AppState(chatEventId: ''),
        ));

  void init() async {
    _instance.collection('appState').doc('appState').snapshots().listen(
      (event) {
        var appState = event.data();
        emit(state.copyWith(appState: AppState.fromMap(appState!)));
      },
    );

    //emit(state.copyWith(appState: appState));
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

  ThemeData fetchTheme() {
    return state.appState.isLightTheme ? lightThemeData : darkThemeData;
  }
}
