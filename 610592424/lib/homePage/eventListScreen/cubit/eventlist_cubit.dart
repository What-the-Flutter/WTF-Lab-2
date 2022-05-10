import 'package:bloc/bloc.dart';
import 'package:diploma/homePage/models/event_holder.dart';
import 'package:flutter/services.dart';

import 'package:diploma/homePage/models/event.dart';
import 'package:diploma/homePage/nominalDataBase/db_context.dart';
import 'eventlist_state.dart';

class EventListCubit extends Cubit<EventListState> {
  late int _eventHolderId;

  EventListCubit(int eventHolderId) : super(EventListState([])) {
    _eventHolderId = eventHolderId;
  }

  final DBContext _db = DBContext();

  void init() async {
    emit(EventListState(await _db.getAllEventsForEventHolder(_eventHolderId)));
  }

  int get eventsSelected =>
      state.events.where((element) => element.isSelected == true).length;

  Future<List<EventHolder>> getEventForwardingHoldersList() async {
    return await _db.getAllEventHolders(_eventHolderId);
  }

  Event getSingleSelected() {
    return state.events.singleWhere((element) => element.isSelected);
  }

  Event getEvent(int id) {
    return state.events.singleWhere((element) => element.eventId == id);
  }

  void changeEventSelection(int id) {
    var event = state.events.singleWhere((element) => element.eventId == id);
    event.isSelected = !event.isSelected;

    emit(state.copyWith(state.events));
  }

  void deselectAllEvents() {
    state.events
        .where((element) => element.isSelected == true)
        .forEach((element) {
      element.isSelected = false;
    });

    emit(state.copyWith(state.events));
  }

  void addEvent(Event event) async {
    await _db.addEvent(
      Event(
        -1,
        event.text,
        _eventHolderId,
        event.iconIndex,
      ),
    );

    init();
  }

  void editEvent(Event newEvent) async {
    newEvent.eventholderId = _eventHolderId;

    _db.updateEvent(newEvent);

    init();
  }

  void deleteAllSelected() {
    state.events.where((element) => element.isSelected).forEach((element) {
      _db.deleteEvent(element.eventId);
    });
    init();
  }

  void copyAllSelected() {
    var text = "";

    state.events.where((element) => element.isSelected).forEach((element) {
      text += "${element.text} ";
    });

    Clipboard.setData(ClipboardData(text: text));

    deselectAllEvents();
  }

  void forwardAllSelected(int newEventHolderId) {
    state.events.where((element) => element.isSelected).forEach((element) async {
      element.eventholderId = newEventHolderId;
      await _db.updateEvent(element);
    });

    init();
  }

  void applySearch(String enteredString) async {
    var exp = RegExp(enteredString);
    var tempList = await _db.getAllEventsForEventHolder(_eventHolderId);
    emit(state.copyWith(
      tempList.where((element) => exp.hasMatch(element.text)).toList(),
    ));
  }
}
