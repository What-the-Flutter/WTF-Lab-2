import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../models/event.dart';
import '../../../../repository/database_repository.dart';

part 'event_state.dart';

class EventCubit extends Cubit<EventState> {
  DataBaseRepository dataBaseRepository;

  EventCubit({required this.dataBaseRepository})
      : super(EventState(eventList: []));

  Future<void> getEvents() async {
    final _newList = await dataBaseRepository.getEvents();
    state.eventList.clear();
    state.eventList.addAll(_newList);

    emit(
      EventState(eventList: state.eventList),
    );
  }

  Future<void> addEvent({
    required String categoryTitle,
    required Event event,
  }) async {
    dataBaseRepository.addEvent(event);
    final _changes = await dataBaseRepository.updateEvents(state.eventList);

    emit(
      EventState(eventList: _changes),
    );
  }

  Future<void> removeEventInCategory({required String key}) async {
    dataBaseRepository.removeEvent(key);
    state.eventList.clear();
    state.eventList.addAll(
      await dataBaseRepository.getEvents(),
    );
    emit(
      EventState(eventList: state.eventList),
    );
  }

  void eventRename({
    required String key,
    required String newTitle,
  }) async {
    dataBaseRepository.renameEvent(key, newTitle);
    state.eventList.clear();
    state.eventList.addAll(
      await dataBaseRepository.getEvents(),
    );

    emit(
      EventState(eventList: state.eventList),
    );
  }

  Future<void> bookMarkEvent({
    required String key,
    required bool isBook,
  }) async {
    dataBaseRepository.bookmarkEvent(key, isBook);
    state.eventList.clear();
    state.eventList.addAll(
      await dataBaseRepository.getEvents(),
    );

    emit(
      EventState(eventList: state.eventList),
    );
  }

  Future<void> eventSelect(String key) async {
    dataBaseRepository.eventSelected(key);
    state.eventList.clear();
    state.eventList.addAll(
      await dataBaseRepository.getEvents(),
    );
    emit(
      EventState(eventList: state.eventList),
    );
  }

  Future<void> eventNotSelect(String key) async {
    dataBaseRepository.eventNotSelected(key);
    state.eventList.clear();
    state.eventList.addAll(
      await dataBaseRepository.getEvents(),
    );
    emit(
      EventState(eventList: state.eventList),
    );
  }

  Future<void> moveEvent(String key, String newCategory) async {
    dataBaseRepository.moveEvent(
      key,
      newCategory,
    );
    state.eventList.clear();
    state.eventList.addAll(
      await dataBaseRepository.getEvents(),
    );

    emit(
      EventState(eventList: state.eventList),
    );
  }

  void getImage(String name) async {
    final url = await dataBaseRepository.getImageUrl(name);
    for (var element in state.eventList) {
      if (element.title == name) {
        element.imageUrl = url;
      }
    }

    emit(
      EventState(eventList: state.eventList),
    );
  }
}
