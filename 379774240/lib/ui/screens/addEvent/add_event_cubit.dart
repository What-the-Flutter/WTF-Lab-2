import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../data/models/event.dart';
import '../../../domain/database/database_provider.dart';

part 'add_event_state.dart';

class AddEventCubit extends Cubit<AddEventState> {
  final DatabaseProvider _databaseProvider = DatabaseProvider();
  AddEventCubit() : super(AddEventState());

  void selectIcon(int iconIndex) {
    var currentSelectedIcon = state.selectedIcon;
    if (currentSelectedIcon == iconIndex) {
      emit(state.copyWith(selectedIcon: -1));
    } else {
      emit(state.copyWith(selectedIcon: iconIndex));
    }
  }

  Future<bool> setEventName(String eventName) async {
    var events = await DatabaseProvider().fetchEvents();
    var alreadyCreatedEvent = false;
    for (var element in events) {
      if (element.title.toLowerCase() == eventName.toLowerCase()) {
        alreadyCreatedEvent = true;
      }
    }
    if (!alreadyCreatedEvent) {
      emit(state.copyWith(eventName: eventName));
      return true;
    } else {
      return false;
    }
  }

  void addEvent() {
    var event = Event(
      title: state.eventName,
      lastMessage: 'No messages',
      iconData: state.icons[state.selectedIcon!],
      lastActivity: '',
    );
    _databaseProvider.createEvent(event);
  }
}
