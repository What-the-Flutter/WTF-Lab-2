import 'package:bloc/bloc.dart';
import 'package:diploma/data_base/repositories/eventholders_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hashtagable/hashtagable.dart';

import 'package:diploma/data_base/repositories/events_repository.dart';
import 'package:diploma/models/event_holder.dart';
import 'package:diploma/models/event.dart';
import 'package:diploma/widgets/events_app_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'eventlist_state.dart';

class EventListCubit extends Cubit<EventListState> {
  final int _eventHolderId;
  late final EventsRepository _eventsRepo;
  late final EventHoldersRepository _eventHoldersRepo;

  EventListCubit(this._eventHolderId)
      : super(EventListState(
          events: [],
          anyHashtags: false,
          appbarState: AppbarStates.normal,
          showIconsList: false,
          chosenIconIndex: 0,
          allowPhotoPick: true,
          tempEventId: null,
        )) {
    _eventsRepo = EventsRepository();
    _eventHoldersRepo = EventHoldersRepository();
    loadEvents();
  }

  int get getEventsSelectedNumber =>
      state.events.where((element) => element.isSelected == true).length;

  Future<List<EventHolder>> get getEventForwardingHoldersList async =>
      await _eventHoldersRepo.loadAllEventHolders(_eventHolderId);

  Event get getSingleSelectedEvent =>
      state.events.singleWhere((element) => element.isSelected);

  void setAllowImagePick(String text) =>
      emit(state.copyWith(allowPhotoPick: text.isEmpty));

  void changeIconListVisibility() =>
      emit(state.copyWith(showIconsList: !state.showIconsList));

  void setChosenIcon(int iconIndex) {
    emit(state.copyWith(chosenIconIndex: iconIndex));
    changeIconListVisibility();
  }

  void setAppbarState(AppbarStates newAppbarState) =>
      emit(state.copyWith(appbarState: newAppbarState));

  void setNormalAppbarState() {
    emit(state.copyWith(
      appbarState: AppbarStates.normal,
      tempEventId: null,
      chosenIconIndex: 0,
    ));
    loadEvents();
  }

  void setEditingAppbarState() {
    assert(state.appbarState == AppbarStates.singleSelected);
    final tempEvent = getSingleSelectedEvent;
    emit(state.copyWith(
      appbarState: AppbarStates.editing,
      tempEventId: tempEvent.eventId,
      chosenIconIndex: tempEvent.iconIndex ?? 0,
    ));
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

  void loadEvents() async {
    emit(state.copyWith(
        events: await _eventsRepo.getAllEventsForEventHolder(_eventHolderId)));
    await checkHashTags();
  }

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

  void addEvent(String text) async {
    assert(state.appbarState == AppbarStates.normal);

    await _eventsRepo.addEvent(
      text: text,
      eventholderId: _eventHolderId,
      iconIndex: state.chosenIconIndex == 0 ? null : state.chosenIconIndex,
    );

    setNormalAppbarState();
  }

  void editEvent(String newText) async {
    assert(state.tempEventId != null);
    assert(state.appbarState == AppbarStates.editing);
    await _eventsRepo.updateEvent(
      eventId: state.tempEventId!,
      text: newText,
      iconIndex: state.chosenIconIndex == 0 ? null : state.chosenIconIndex,
      eventholderId: _eventHolderId,
      timeOfCreation: getSingleSelectedEvent.timeOfCreation,
    );
    setNormalAppbarState();
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

  void forwardAllSelected(int newEventHolderId) {
    state.events
        .where((element) => element.isSelected)
        .forEach((element) async {
      await _eventsRepo.updateEvent(
        eventholderId: newEventHolderId,
        iconIndex: element.iconIndex,
        text: element.text,
        eventId: element.eventId,
        timeOfCreation: element.timeOfCreation,
      );
    });

    setNormalAppbarState();
  }

  void applySearch(String enteredString) async {
    final exp = RegExp(enteredString);
    final tempList =
        await _eventsRepo.getAllEventsForEventHolder(_eventHolderId);
    emit(state.copyWith(
      events: tempList.where((element) => exp.hasMatch(element.text)).toList(),
    ));
  }

  checkHashTags() async {
    for (var event
        in await _eventsRepo.getAllEventsForEventHolder(_eventHolderId)) {
      if (hasHashTags(event.text)) {
        emit(state.copyWith(anyHashtags: true));
        return;
      }
    }
    emit(state.copyWith(anyHashtags: false));
  }

  Future<List<String>> fetchAllHashTags() async {
    final List<String> _hashTags = [];
    for (var event
        in await _eventsRepo.getAllEventsForEventHolder(_eventHolderId)) {
      _hashTags.addAll(extractHashTags(event.text));
    }
    return _hashTags;
  }

  Future attachImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    await _eventsRepo.addEvent(
      eventholderId: _eventHolderId,
      imagePath: image.path,
    );
  }

  Future<Image> fetchImage(int id) async => await _eventsRepo.fetchImage(id);
}
