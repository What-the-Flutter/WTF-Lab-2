import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/event.dart';
import '../../../../repository/database_repository.dart';

part 'event_state.dart';

class EventCubit extends Cubit<EventState> {
  DataBaseRepository dataBaseRepository;

  EventCubit({required this.dataBaseRepository})
      : super(const EventState(eventList: []));

  Future<void> getEvents() async {
    final _newList = await dataBaseRepository.getEvents();

    emit(
      EventState(eventList: _newList).copyWith(animate: false),
    );
  }

  Future<void> addEvent({
    required Event event,
  }) async {
    await dataBaseRepository.addEvent(event);
    final _changes = await dataBaseRepository.updateEvents(state.eventList);
    emit(
      EventState(eventList: _changes),
    );
  }

  Future<void> removeEventInCategory({required String key}) async {
    await dataBaseRepository.removeEvent(key);

    final _changes = await dataBaseRepository.getEvents();

    emit(
      EventState(eventList: _changes).copyWith(hasSelected: []),
    );
  }

  Future<void> removeMultipleEvents() async {
    for (final el in state.hasSelected) {
      await dataBaseRepository.removeEvent(el);
    }

    final _changes = await dataBaseRepository.updateEvents(state.eventList);

    emit(
      EventState(eventList: _changes).copyWith(hasSelected: []),
    );
  }

  void eventRename({
    required String key,
    required String newTitle,
  }) async {
    dataBaseRepository.renameEvent(key, newTitle);
    final _changes = await dataBaseRepository.getEvents();

    emit(
      state.copyWith(eventList: _changes),
    );
  }

  Future<void> bookMarkEvent({
    required String key,
    required bool isBook,
  }) async {
    dataBaseRepository.bookmarkEvent(key, isBook);
    final _changes = await dataBaseRepository.updateEvents(state.eventList);

    emit(
      EventState(eventList: _changes).copyWith(animate: !isBook),
    );
  }

  Future<void> eventSelect(String key) async {
    dataBaseRepository.eventSelected(key);
    final _changes = await dataBaseRepository.getEvents();
    final _selected = <String>[];
    _selected.addAll(state.hasSelected);
    _selected.add(key);

    emit(
      EventState(eventList: _changes).copyWith(hasSelected: _selected),
    );
  }

  Future<void> eventNotSelect(String key) async {
    dataBaseRepository.eventNotSelected(key);
    final _changes = await dataBaseRepository.getEvents();
    final _selected = <String>[];
    _selected.addAll(state.hasSelected);

    _selected.remove(key);
    emit(
      EventState(eventList: _changes).copyWith(hasSelected: _selected),
    );
  }

  void clearHasSelected() {
    emit(state.copyWith(hasSelected: []));
  }

  Future<void> moveEvent(String key, String newCategory) async {
    dataBaseRepository.moveEvent(
      key,
      newCategory,
    );

    final _changes = await dataBaseRepository.getEvents();

    emit(
      state.copyWith(eventList: _changes),
    );
  }

  void iconSelect(int i) {
    emit(
      state.copyWith(selectedIcon: i),
    );
  }

  void tagSelect(int i) {
    emit(
      state.copyWith(selectedTag: i),
    );
  }

  void iconAdd(bool value) {
    emit(
      state.copyWith(iconAdd: value),
    );
  }

  void stopAnimate() {
    emit(state.copyWith(animate: false));
  }

  void imageSelect(String? image) {
    emit(state.copyWith(selectedImage: image));
  }
}
