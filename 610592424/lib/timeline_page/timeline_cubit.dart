import 'package:bloc/bloc.dart';
import 'package:diploma/home_page/models/event_holder.dart';
import 'package:diploma/data_base/firebase_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hashtagable/hashtagable.dart';

import 'package:diploma/home_page/models/event.dart';
import 'timeline_state.dart';

class TimelineCubit extends Cubit<TimelineState> {
  late final FireBaseProvider _db;

  TimelineCubit()
      : super(TimelineState([], false, [])) {
    _db = FireBaseProvider();
  }

  Future<String> getEventHolderName(int id) async {
   var eventholder = await _db.getEventHolder(id);

   return eventholder.title;
  }

  Future<List<EventHolder>> getEventHoldersFiltersList() async {
    return await _db.getAllEventHolders();
  }

  void onEventholderFilterTap(int id){
    if(isEventholderSelected(id)) {
      state.eventHoldersFilter.removeWhere((element) => element == id);
    }
    else {
      state.eventHoldersFilter.add(id);
    }
    emit(state.copyWith());
  }

  bool isEventholderSelected(int id) {
    return state.eventHoldersFilter.any((element) => element == id);
  }

  void loadAllEvents() async {
    emit(state.copyWith(events: await _db.getAllEvents()));
    await checkHashTags();
  }

  void applyFilter() async {
    if (state.eventHoldersFilter.isNotEmpty) {
      final List<Event> _events = [];
      for (var id in state.eventHoldersFilter) {
        _events.addAll(await _db.getAllEventsForEventHolder(id));
      }
      _events.sort((a, b) => a.eventId.compareTo(b.eventId));
      emit(state.copyWith(events: _events));
    } else {
      loadAllEvents();
    }
  }

  checkHashTags() async {
    for (var event in await _db.getAllEvents()) {
      if (hasHashTags(event.text)) {
        emit(state.copyWith(anyHashtags: true));
        return;
      }
    }
    emit(state.copyWith(anyHashtags: false));
  }

  Future<List<String>> getAllHashTags() async {
    final List<String> _hashTags = [];
    for (var event in await _db.getAllEvents()) {
      _hashTags.addAll(extractHashTags(event.text));
    }
    return _hashTags;
  }

  int get eventsSelected =>
      state.events.where((element) => element.isSelected == true).length;

  Event getSingleSelected() {
    return state.events.singleWhere((element) => element.isSelected);
  }

  Event getEvent(int id) {
    return state.events.singleWhere((element) => element.eventId == id);
  }

  void changeEventSelection(int id) {
    var event = state.events.singleWhere((element) => element.eventId == id);
    event.isSelected = !event.isSelected;

    emit(state.copyWith(events: state.events));
  }

  void deselectAllEvents() {
    state.events
        .where((element) => element.isSelected == true)
        .forEach((element) {
      element.isSelected = false;
    });

    emit(state.copyWith(events: state.events));
  }

  void deleteAllSelected() {
    state.events.where((element) => element.isSelected).forEach((element) {
      _db.deleteEvent(element.eventId, hasImage: element.imagePath != null);
    });
    loadAllEvents();
  }

  void copyAllSelected() {
    var text = "";

    state.events.where((element) => element.isSelected).forEach((element) {
      text += "${element.text} ";
    });

    Clipboard.setData(ClipboardData(text: text));

    deselectAllEvents();
  }

  void applySearch(String enteredString) async {
    var exp = RegExp(enteredString);
    var tempList = await _db.getAllEvents();
    emit(state.copyWith(
      events: tempList.where((element) => exp.hasMatch(element.text)).toList(),
    ));
  }

  Future<Image> fetchImage(int id) async {
    return Image.memory(await _db.fetchImage(id));
  }
}
