import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import '../../data/models/event.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<List<Event>> {
  ChatCubit(super.events);

  void addEvent(Event event) {
    var newState = state;
    newState.add(event);
    emit(newState);
  }

  List<Event> fetchEvents() {
    return state;
  }
}
