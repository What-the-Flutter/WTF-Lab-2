import 'package:bloc/bloc.dart';

import 'package:diploma/models/event_holder.dart';
import 'package:diploma/data_base/repositories/eventholders_repository.dart';
import 'eventholder_state.dart';

class EventHolderCubit extends Cubit<EventHolderState> {
  late final EventHoldersRepository _repo;

  EventHolderCubit() : super(EventHolderState([])) {
    _repo = EventHoldersRepository();
    loadEventHolders();
  }

  void loadEventHolders() async =>
      emit(EventHolderState(await _repo.loadAllEventHolders()));

  Future<EventHolder> fetchEventHolder(int id) async =>
      await _repo.fetchEventHolder(id);

  Future<String> fetchEventHolderLastEventText(int id) async =>
      await _repo.fetchEventHolderLastEventText(id);

  void addEventHolder(EventHolder tempEventHolder) async {
    await _repo.addEventHolder(tempEventHolder);
    loadEventHolders();
  }

  void editEventHolder(EventHolder newEventHolder) async {
    await _repo.updateEventHolder(newEventHolder);
    loadEventHolders();
  }

  void deleteEventHolder(int id) async {
    await _repo.deleteEventHolder(id);
    loadEventHolders();
  }
}
