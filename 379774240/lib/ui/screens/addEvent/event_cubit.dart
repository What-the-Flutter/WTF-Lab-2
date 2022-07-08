import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../domain/database_provider.dart';
import '../../../domain/models/event.dart';

part 'event_state.dart';

class EventCubit extends Cubit<EventState> {
  EventCubit() : super(const EventState());

  void selectIcon(int index) {
    emit(state.copyWith(
        selectedIcon: state.selectedIcon == index ? null : index));
  }

  Future<void> createEvent(Event event) async {
    await DatabaseProvider.instance.createEvent(event);
  }
}
