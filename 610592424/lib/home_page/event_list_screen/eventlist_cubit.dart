import 'package:bloc/bloc.dart';
import 'package:diploma/data_base/firebase_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hashtagable/hashtagable.dart';

import 'package:diploma/home_page/models/event_holder.dart';
import 'package:diploma/home_page/models/event.dart';
import 'package:image_picker/image_picker.dart';
import 'eventlist_state.dart';

class EventListCubit extends Cubit<EventListState> {
  final int _eventHolderId;
  late final FireBaseProvider _db;

  EventListCubit(this._eventHolderId,) : super(EventListState([], false)) {
    _db = FireBaseProvider();
  }

  void init() async {
    emit(state.copyWith(await _db.getAllEventsForEventHolder(_eventHolderId)));
    await checkHashTags();
  }

  checkHashTags() async {
    for (var event in await _db.getAllEventsForEventHolder(_eventHolderId)) {
      if(hasHashTags(event.text)) {
        emit(state.copyWith(null, true));
        return;
      }
    }
    emit(state.copyWith(null, false));
  }
  
  Future<List<String>> getAllHashTags() async {
    List<String> _hashTags = [];
    for (var event in await _db.getAllEventsForEventHolder(_eventHolderId)) {
      _hashTags.addAll(extractHashTags(event.text));
    }
    return _hashTags;
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
      Event.withoutId(
        text: event.text,
        eventholderId: _eventHolderId,
        iconIndex: event.iconIndex,
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
      _db.deleteEvent(element.eventId, hasImage: element.imagePath != null);
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
    state.events
        .where((element) => element.isSelected)
        .forEach((element) async {
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

  Future attachImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final event = Event.withoutId(
      text: '',
      eventholderId: _eventHolderId,
      imagePath: image.path,
    );
    await _db.addEvent(event);
  }

  Future<Image> fetchImage(int id) async {
    return Image.memory(await _db.fetchImage(id));
  }
}
