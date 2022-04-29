import 'package:bloc/bloc.dart';
import 'package:diploma/NewHome/EventHolder/Models/event_holder.dart';
import 'package:diploma/NewHome/NominalDataBase/event_holders_list.dart';
import 'package:flutter/services.dart';
import '../Models/event.dart';

class EventListCubit extends Cubit<List<Event>> {
  late EventHolder _eventHolder;

  EventListCubit(int eventHolderId)
      : super(myEventHolders
            .firstWhere((element) => element.id == eventHolderId)
            .events) {
    _eventHolder =
        myEventHolders.singleWhere((element) => element.id == eventHolderId);
  }

  int get eventsSelected =>
      _eventHolder.events.where((element) => element.isSelected == true).length;

  String get eventHolderTitle => _eventHolder.title;

  List<EventHolder> getEventForwardingHoldersList() {
    return myEventHolders
        .where((element) => element.id != _eventHolder.id)
        .toList();
  }

  Event getSingleSelected() {
    return _eventHolder.events.singleWhere((element) => element.isSelected);
  }

  Event getEvent(int id) {
    return _eventHolder.events.singleWhere((element) => element.id == id);
  }

  void changeEventSelection(int id) {
    var event = _eventHolder.events.singleWhere((element) => element.id == id);
    event.isSelected = !event.isSelected;

    emit(state);
  }

  void deselectAllEvents() {
    _eventHolder.events
        .where((element) => element.isSelected == true)
        .forEach((element) {
      element.isSelected = false;
    });

    emit(_eventHolder.events.toList());
  }

  void addEvent(Event event) {
    Event tempEvent = Event(
      _eventHolder.events.isNotEmpty ? _eventHolder.events.last.id + 1 : 0,
      event.text,
      event.icon,
    );
    _eventHolder.events.add(tempEvent);

    emit(_eventHolder.events.toList());
  }

  void editEvent(Event newEvent) {
    Event oldEvent =
        _eventHolder.events.firstWhere((element) => element.id == newEvent.id);

    oldEvent.text = newEvent.text;
    oldEvent.icon = newEvent.icon;

    deselectAllEvents();
  }

  void deleteAllSelected() {
    _eventHolder.events.removeWhere((element) => element.isSelected);
    emit(_eventHolder.events.toList());
  }

  void copyAllSelected() {
    var text = "";

    _eventHolder.events
        .where((element) => element.isSelected)
        .forEach((element) {
      text += "${element.text} ";
    });

    Clipboard.setData(ClipboardData(text: text));

    deselectAllEvents();
  }

  void forwardAllSelected(int newEventHolderId) {
    myEventHolders
        .firstWhere((element) => element.id == newEventHolderId)
        .events
        .addAll(_eventHolder.events.where((element) => element.isSelected));

    _eventHolder.events.removeWhere((element) => element.isSelected);

    emit(_eventHolder.events.toList());
  }

  void applySearch(String enteredString) {
    var exp = RegExp(enteredString);
    emit(_eventHolder.events
        .where((element) => exp.hasMatch(element.text))
        .toList());
  }
}
