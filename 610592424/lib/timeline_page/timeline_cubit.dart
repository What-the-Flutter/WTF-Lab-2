import 'package:bloc/bloc.dart';
import 'package:diploma/data_base/repositories/eventholders_repository.dart';
import 'package:diploma/models/event_holder.dart';
import 'package:diploma/data_base/repositories/events_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hashtagable/hashtagable.dart';
import 'package:diploma/widgets/events_app_bar.dart';

import 'package:diploma/models/event.dart';
import 'timeline_state.dart';

class TimelineCubit extends Cubit<TimelineState> {
  late final EventsRepository _eventsRepo;
  late final EventHoldersRepository _eventHoldersRepo;

  TimelineCubit() : super(TimelineState([], false, [], AppbarStates.normal)) {
    _eventsRepo = EventsRepository();
    _eventHoldersRepo = EventHoldersRepository();
    loadAllEvents();
  }

  void setAppbarState(AppbarStates newAppbarState) =>
      emit(state.copyWith(appbarState: newAppbarState));

  void setNormalAppbarState() {
    emit(state.copyWith(appbarState: AppbarStates.normal));
    loadAllEvents();
  }

  void setSearchingAppbarState() {
    emit(state.copyWith(appbarState: AppbarStates.searching));
    applySearch('');
  }

  void onEventTapOrPress(int eventId) {
    if (state.appbarState != AppbarStates.editing) {
      changeEventSelection(eventId);
      final itemsSelected = getEventsSelectedNumber;
      if (itemsSelected == 0) {
        setNormalAppbarState();
      } else if (itemsSelected == 1) {
        setAppbarState(AppbarStates.singleSelected);
      } else {
        setAppbarState(AppbarStates.multiSelected);
      }
    }
  }

  Future<String> fetchEventHolderName(int id) async {
    final eventholder = await _eventHoldersRepo.fetchEventHolder(id);
    return eventholder.title;
  }

  Future<List<EventHolder>> get getEventHoldersFiltersList async =>
      await _eventHoldersRepo.loadAllEventHolders();

  void onEventholderFilterTap(int id) {
    if (isEventholderSelected(id)) {
      state.eventHoldersFilter.removeWhere((element) => element == id);
    } else {
      state.eventHoldersFilter.add(id);
    }
    emit(state.copyWith());
  }

  bool isEventholderSelected(int id) =>
      state.eventHoldersFilter.any((element) => element == id);

  void loadAllEvents() async {
    final _events = await _eventsRepo.loadAllEvents();
    //_events.sort((a, b) => a.eventId.compareTo(b.eventId));
    emit(state.copyWith(events: _events));
    await checkHashTags();
  }

  void applyFilter() async {
    if (state.eventHoldersFilter.isNotEmpty) {
      final List<Event> _events = [];
      for (var id in state.eventHoldersFilter) {
        _events.addAll(await _eventsRepo.getAllEventsForEventHolder(id));
      }
      _events.sort((a, b) => a.eventId.compareTo(b.eventId));
      emit(state.copyWith(events: _events));
    } else {
      loadAllEvents();
    }
  }

  checkHashTags() async {
    for (var event in await _eventsRepo.loadAllEvents()) {
      if (hasHashTags(event.text)) {
        emit(state.copyWith(anyHashtags: true));
        return;
      }
    }
    emit(state.copyWith(anyHashtags: false));
  }

  Future<List<String>> fetchAllHashTags() async {
    final List<String> _hashTags = [];
    for (var event in await _eventsRepo.loadAllEvents()) {
      _hashTags.addAll(extractHashTags(event.text));
    }
    return _hashTags;
  }

  int get getEventsSelectedNumber =>
      state.events.where((element) => element.isSelected == true).length;

  Event get getSingleSelected =>
      state.events.singleWhere((element) => element.isSelected);

  Event fetchEvent(int id) =>
      state.events.singleWhere((element) => element.eventId == id);

  void changeEventSelection(int id) {
    final event = state.events.singleWhere((element) => element.eventId == id);
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

  void deleteAllSelected() async {
    state.events
        .where((element) => element.isSelected)
        .forEach((element) async {
      await _eventsRepo.deleteEvent(element);
    });
    setNormalAppbarState();
  }

  void copyAllSelected() {
    var text = "";

    state.events.where((element) => element.isSelected).forEach((element) {
      text += "${element.text} ";
    });

    Clipboard.setData(ClipboardData(text: text));

    setNormalAppbarState();
  }

  void applySearch(String enteredString) async {
    final exp = RegExp(enteredString);
    final tempList = await _eventsRepo.loadAllEvents();
    emit(state.copyWith(
      events: tempList.where((element) => exp.hasMatch(element.text)).toList(),
    ));
  }

  Future<Image> fetchImage(int id) async => await _eventsRepo.fetchImage(id);
}
