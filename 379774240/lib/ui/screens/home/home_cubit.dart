import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../data/models/app_state.dart';
import '../../../data/models/event.dart';
import '../../../domain/database/database_provider.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final dbProvider = DatabaseProvider();

  HomeCubit() : super(HomeState());

  void init() async {
    _fetchEventsToState();
  }

  void likeEvent(Event event) {
    dbProvider.updateEvent(
      event.id!,
      event.copyWith(
        isFavorite: !event.isFavorite,
      ),
    );
  }

  void deleteEvent(Event event) {
    dbProvider.deleteEvent(
      event.id!,
    );
  }

  void setSelectedEvent(Event event) {
    emit(state.copyWith(
      appState: state.appState.copyWith(
        selectedEventId: event.id,
      ),
    ));
    dbProvider.updateAppState(state.appState);
  }

  void _fetchEventsToState() {
    dbProvider.listenEvents().listen((event) {
      var events = <Event>[];
      var data = (event.snapshot.value ?? {}) as Map;
      data.forEach(((key, value) {
        events.add(Event.fromMap({'id': key, ...value}));
      }));
      _sortEventsFromState(events);
    });
  }

  void _sortEventsFromState(List<Event> events) {
    var favoriveEvents = <Event>[];
    var commonEvents = <Event>[];
    for (var element in events) {
      if (element.isFavorite) {
        favoriveEvents.add(element);
      } else {
        commonEvents.add(element);
      }
    }
    emit(state.copyWith(
      favoriteEvents: favoriveEvents,
      events: commonEvents,
    ));
  }

  void selectPage(int index) {
    if (index == state.selectedItemInNavBar) return;
    emit(state.copyWith(selectedItemInNavBar: index));
  }
}
