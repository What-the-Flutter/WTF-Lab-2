import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../domain/models/event.dart';

part 'event_state.dart';

class EventCubit extends Cubit<EventState> {
  EventCubit() : super(const EventState());

  void selectIcon(int index) {
    emit(state.copyWith(
        selectedIcon: state.selectedIcon == index ? null : index));
  }

  Future<void> createEvent(Event event) async {
    final docEvent = FirebaseFirestore.instance.collection('events').doc();
    var newEvent = event.copyWith(id: docEvent.id);
    await docEvent.set(newEvent.toMap());
  }
}
